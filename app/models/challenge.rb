class Challenge < ActiveRecord::Base
  #require 'language_processing'
  attr_accessible :challenge_id, :description, :end_date, :followers, :start_date, :title
  #include LanguageProcessing

  def stop_words
    # PROCESS (1): plain text
    text = description
    stop_words = []

    # read file including all stop words
    File.open(Dir.pwd + '/app/assets/documents/stopwords_en.txt', 'r').each_line do |line|
      stop_words.push(line.strip)
    end

    # remove lowercase stop words and select only letters (no numbers and special chars)
    words = text.scan(/\w+/)
    key_lower = words.select { |word| !stop_words.include?(word) && word =~ /^[a-zA-Z]*$/ }

    # remove capitalized stop words
    stop_words = stop_words.map { |key| key.capitalize }
    key_words = key_lower.select { |word| !stop_words.include?(word) }

    # output new string excluding stop words
    stop_word_text = key_words.join(' ')
  end

  def lemma
    # PROCESS (2): stop words text
    text = stop_words
    lemma_text = []

    # use language
    # :english, :french, :german
    StanfordCoreNLP.use :english

    # Available property key names for annotations
    # :tokenize, :ssplit, :pos, :lemma, :parse, :ner, :dcoref
    pipeline =  StanfordCoreNLP.load(:tokenize, :ssplit, :pos, :lemma)
    text = StanfordCoreNLP::Annotation.new(text)
    pipeline.annotate(text)

    # get all pos tokens and save them
    text.get(:tokens).each do |token|
      lemmatized_word = token.get(:lemma).to_s.downcase
      lemma_text.push(lemmatized_word)
    end
    lemma_text
  end

  def pos_tags
    # PROCESS (3): lemmatized text
    text = lemma.join(' ')
    pos_tokens = []

    # use language
    # :english, :french, :german
    StanfordCoreNLP.use :english

    # Available property key names for annotations
    # :tokenize, :ssplit, :pos, :lemma, :parse, :ner, :dcoref
    pipeline =  StanfordCoreNLP.load(:tokenize, :ssplit, :pos)
    text = StanfordCoreNLP::Annotation.new(text)
    pipeline.annotate(text)

    # get all pos tokens and save them
    text.get(:tokens).each do |token|
      pos_tokens.push([token.get(:original_text).to_s, token.get(:part_of_speech).to_s])
    end
    pos_tokens
  end

  def tf_idf(term)
    # calculate the normalised term frequency
    # by applying the frequency of all terms
    # tf(t,d) = f(t,d) / sum(f(w,d))
    f = lemma.count(term)       # count of specific term
    sum_w = lemma.size          # count of all terms
    tf = f.to_f / sum_w

    # calculate the inversed document frequency
    # idf(t,D) = log(sum(D) / {sum(d), t ∈ d})
    sum_D = self.class.all.size # count of all documents
    sum_d = 0                   # count of documents the term appears in
    self.class.all.each do |document|
      if document.lemma.include?(term)
        sum_d += 1
      end
    end
    # absolute number are used to guarantee positive results (see literature)
    idf = Math.log(sum_D.abs.to_f / sum_d.abs)

    # calculate the relative importance of the term: tf-idf
    tf_idf = tf * idf
  end

  def document_vector
    vector = []
    dictionary = TermMatrix.new.create_dictionary
    dictionary.each do |term|
      if lemma.include?(term)
        vector[dictionary.index(term)] = tf_idf(term)
      else
        vector[dictionary.index(term)] = 0
      end
    end
    vector
  end
end
