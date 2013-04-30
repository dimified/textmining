module LanguageProcessing

  def processed_text
    # Natural Language Preprocessing of original text
    original_text = description.scan(/\w+[^\d\W_]/).join(' ').downcase
    processed_text = []

    # use language
    # :english, :french, :german
    StanfordCoreNLP.use :english

    # Available property key names for annotations
    # :tokenize, :ssplit, :pos, :lemma, :parse, :ner, :dcoref
    pipeline =  StanfordCoreNLP.load(:tokenize, :ssplit, :pos, :lemma)
    text = StanfordCoreNLP::Annotation.new(original_text)
    pipeline.annotate(text)

    # get all tokens and save them
    text.get(:sentences).each do |sentence|
      sentence.get(:tokens).each do |token|
        # include only words which are not in the stop words list
        unless $stop_words.include?(token.get(:original_text).to_s)
          processed_text << token.get(:lemma).to_s
        end
      end
     end
    processed_text
  end

  def tf_idf(term)
    # calculate the normalised term frequency
    # by applying the frequency of all terms
    # tf(t,d) = f(t,d) / sum(f(w,d))
    # count of specific term / count of all words within the document 
    tf = $dictionary[term][0].to_f / lemma.split.size   

    # calculate the inversed document frequency
    # idf(t,D) = log(sum(D) / {sum(d), t ∈ d})
    # count of all documents / count of documents the term appears in
    # absolute number are used to guarantee positive results (see literature)
    idf = Math.log10($record_size / $dictionary[term][1])

    # calculate the relative importance of the term: tf-idf
    tf_idf = tf * idf
    tf_idf.round(5)
  end

  def document_vector
    vector = []
    dictionary_list = $dictionary.each_key.to_a

    # compare each term with the existing ones in the dictionary and save tf-idf
    dictionary_list.each do |term|
      if lemma.split.include?(term)
        vector[dictionary_list.index(term)] = tf_idf(term)
      else
        vector[dictionary_list.index(term)] = 0
      end
    end
    vector
  end

  def sim_cosinus(d1, d2)
    sum_d0 = 0
    sum_d1 = 0
    sum_d2 = 0
    d1.each_index do |idx|
      sum_d0 += d1[idx] * d2[idx]
      sum_d1 += d1[idx]**2
      sum_d2 += d2[idx]**2
    end
    sim_cosinus = sum_d0 / ( (Math.sqrt(sum_d1)) *  (Math.sqrt(sum_d2)) )
    sim_cosinus.round(5)
  end

 # def sim_pearson(d1, d2)
  #  Statsample::Bivariate.pearson(d1, d2)
  #end

  def sim_vector
    vector = []
    doc_vec = document_vector
    $record_set.each do |record|
      vector << sim_cosinus(doc_vec, record.document_vector)
    end
    vector
  end
end