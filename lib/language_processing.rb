module LanguageProcessing
  def stop_words
    # PROCESS (1): plain text
    text = self.description
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
    text = self.stop_words
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
      unless lemma_text.include?(lemmatized_word)
        lemma_text.push(lemmatized_word)
      end
    end
    lemma_text
  end

  def pos_tags
    # PROCESS (3): lemmatized text
    text = self.lemma.join(' ')
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

  def document_vector
    vector = []
    dictionary = TermMatrix.new.create_dictionary
    dictionary.each do |term|
      if self.lemma.include?(term)
        vector[dictionary.index(term)] = term
      else
        vector[dictionary.index(term)] = 0
      end
    end
    vector
  end
end
