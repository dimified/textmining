module LanguageProcessing

	def processed_text
    # Natural Language Preprocessing of original text
    original_text = description.scan(/\w+[^\d\W_]/).join(' ').downcase
    #processed_text = Hash.new
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
	        #processed_text[token.get(:lemma).to_s] = [token.get(:part_of_speech).to_s, original_text.split.count(token.get(:original_text).to_s)]
	      end
	    end
	   end
    processed_text
  end

  def tf_idf(term)
    # calculate the normalised term frequency
    # by applying the frequency of all terms
    # tf(t,d) = f(t,d) / sum(f(w,d))
    f = $dictionary[term][0]  # count of specific term
    sum_w = lemma.split.size # count of all words within the document
    tf = f.to_f / sum_w

    # calculate the inversed document frequency
    # idf(t,D) = log(sum(D) / {sum(d), t ∈ d})
    sum_D = self.class.all.size      # count of all documents
    sum_d = $dictionary[term][1] # count of documents the term appears in

    # absolute number are used to guarantee positive results (see literature)
    idf = Math.log10(sum_D.abs.to_f / sum_d.abs)

    # calculate the relative importance of the term: tf-idf
    tf_idf = tf * idf
    tf_idf.round(5)
  end

  def document_vector	
    vector = []
    dictionary_list = $dictionary.each_key.to_a

    # compare each term with the existing ones in the dictionary and save tf-idf
    dictionary_list.each do |token|
      if lemma.split.include?(token)
        vector[dictionary_list.index(token)] = tf_idf(token)
      else
        vector[dictionary_list.index(token)] = 0
      end
    end
    vector
  end

  def sim_cosinus(d2)
  	numerator = 0
  	sum_d1 = 0
    sum_d2 = 0

  	document_vector.each_index do |idx|
  		numerator += (document_vector[idx] * d2[idx])
    end

    document_vector.each_index do |idx|
    	sum_d1 += document_vector[idx]**2
    	sum_d2 += d2[idx]**2
    end
    sum_d1 = Math.sqrt(sum_d1)
    sum_d2 = Math.sqrt(sum_d2)
    denominator = sum_d1 * sum_d2

    cosinus = numerator / denominator
    cosinus.round(5)
  end

  def sim_vector
    vector = []
    self.class.all.each do |document|
    	vector << sim_cosinus(document.document_vector)
    end
    vector
  end
end