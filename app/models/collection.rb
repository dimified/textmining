class Collection < ActiveRecord::Base
  attr_accessible :collection_id, :description, :lemma, :title, :document, :user

  def processed_text
    # Natural Language Preprocessing of original text
    original_text = description.scan(/\w+[^\d\W]/).join(' ').downcase
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

  def tf_idf(term)
    # calculate the normalised term frequency
    # by applying the frequency of all terms
    # tf(t,d) = f(t,d) / sum(f(w,d))
    f = processed_text[term][1] # count of specific term
    sum_w = 0 # count of all words within the document
    processed_text.each_value do |value|
      sum_w += value[1]
    end
    sum_w
    tf = f.to_f / sum_w

    ## calculate the inversed document frequency
    ## idf(t,D) = log(sum(D) / {sum(d), t ∈ d})
    sum_D = self.class.all.size # count of all documents
    sum_d = 0                   # count of documents the term appears in
    self.class.all.each do |document|
      if document.processed_text.include?(term)
        sum_d += 1
      end
    end

    ## absolute number are used to guarantee positive results (see literature)
    idf = Math.log(sum_D.abs.to_f / sum_d.abs)

    ## calculate the relative importance of the term: tf-idf
    tf_idf = tf * idf
    tf_idf.round(5)
  end

  def document_vector(dictionary)
    # optional paramaters
    #dictionary = options[:dictionary] || Matrix.new.dictionary

    vector = []

    # compare each term with the existing ones in the dictionary and save tf-idf
    dictionary.each do |term|
      if processed_text.include?(term)
        vector[dictionary.index(term)] = tf_idf(term)
      else
        vector[dictionary.index(term)] = 0
      end
    end
    vector
  end
end
