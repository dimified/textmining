module LanguageProcessing
  def stop_words
    stop_words = []
    text = self.description

    # read file including all stop words
    File.open(Dir.pwd + '/app/assets/documents/stopwords_en.txt', 'r').each_line do |line|
      stop_words.push(line.strip)
    end

    # remove lowercase stop words
    words = text.scan(/\w+/)
    key_lower = words.select { |word| !stop_words.include?(word) }

    # remove capitalized stop words
    stop_words = stop_words.map { |key| key.capitalize }
    key_words = key_lower.select { |word| !stop_words.include?(word) }

    # remove numbers
    key_words.delete_if { |a| a =~ /\d/ }

    # output new string excluding stop words
    text = key_words.join(' ')
  end

  def pos_tags
    text = self.stop_words
    OpenNLP.load

    chunker = OpenNLP::ChunkerME.new
    tokenizer = OpenNLP::TokenizerME.new
    tagger = OpenNLP::POSTaggerME.new

    tokens = tokenizer.tokenize(text).to_a
    tags = tagger.tag(tokens).to_a
  end
end
