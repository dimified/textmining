class Collection < ActiveRecord::Base
  attr_accessible :collection_id, :description, :lemma, :title, :document, :user

  def processed_text
    # Natural Language Preprocessing of original text
    original_text = description.scan(/\w+[^\d\W_]/).join(' ').downcase
    processed_text = Hash.new

    # use language
    # :english, :french, :german
    StanfordCoreNLP.use :english

    # Available property key names for annotations
    # :tokenize, :ssplit, :pos, :lemma, :parse, :ner, :dcoref
    pipeline =  StanfordCoreNLP.load(:tokenize, :ssplit, :pos, :lemma)
    text = StanfordCoreNLP::Annotation.new(original_text)
    pipeline.annotate(text)

    # get all tokens and save them
    text.get(:tokens).each do |token|
      # include only words which are not in the stop words list
      unless $stop_words.include?(token.get(:original_text).to_s)
        # check if token is already included, if yes neglect it
        unless processed_text.flatten.include?(token.get(:lemma).to_s)
          processed_text[token.get(:lemma).to_s] = [token.get(:part_of_speech).to_s, original_text.split.count(token.get(:original_text).to_s)]
        end
      end
    end
    processed_text
  end

  def tf_idf(term, dictionary)
    text = processed_text
    # calculate the normalised term frequency
    # by applying the frequency of all terms
    # tf(t,d) = f(t,d) / sum(f(w,d))
    f = text[term][1] # count of specific term
    sum_w = 0         # count of all words within the document
    text.each_value do |value|
      sum_w = value[1]
    end
    sum_w
    tf = f.to_f / sum_w

    ## calculate the inversed document frequency
    ## idf(t,D) = log(sum(D) / {sum(d), t ∈ d})
    sum_D = Collection.all.size     # count of all documents
    sum_d = dictionary[term]        # count of documents the term appears in

    ## absolute number are used to guarantee positive results (see literature)
    idf = Math.log(sum_D.abs.to_f / sum_d.abs)

    ## calculate the relative importance of the term: tf-idf
    tf_idf = tf * idf
    tf_idf.round(5)
  end

  def document_vector(dictionary)
    vector = []
    dictionary_list = dictionary.each_key.to_a.flatten

    # compare each term with the existing ones in the dictionary and save tf-idf
    dictionary_list.each do |token|
      if lemma.split.include?(token)
        vector[dictionary_list.index(token)] = tf_idf(token, dictionary)
      else
        vector[dictionary_list.index(token)] = 0
      end
    end
    vector
  end
end
