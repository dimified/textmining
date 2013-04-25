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
    pos_tokens = []

    StanfordCoreNLP.use :english

    # Available property key names for annotations
    # :tokenize, :ssplit, :pos, :lemma, :parse, :ner, :dcoref
    pipeline =  StanfordCoreNLP.load(:tokenize, :ssplit, :pos)
    text = StanfordCoreNLP::Annotation.new(text)
    pipeline.annotate(text)

    text.get(:tokens).each do |token|
      pos_tokens.push(token.get(:part_of_speech).to_s)
    end
    pos_tokens
  end
end
