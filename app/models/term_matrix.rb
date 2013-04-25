class TermMatrix < ActiveRecord::Base
  attr_accessible :term, :term_id

  def create_dictionary
    # hash map is twice as faster than saving directly to array
    hash = Hash.new { |h, k| h[k] = [] }

    #models = ActiveRecord::Base.connection.tables.collect{|t| t.underscore.singularize.camelize}
    #models = ['Challenge', 'Comment', 'Contribution']
    models = ['Challenge']

    # generate hash map for all entries
    models.each do |model|
      model.constantize.all.each do |clas|
        words = clas.lemma
        words.each do |word|
          unless hash[word[0]].include?(word)
            hash[word[0]] << word
          end
        end
      end
    end

    # save all entries into an array
    dictionary = []
    hash.each_value do |dict|
      dict.each do |value|
        dictionary.push(value)
      end
    end
    dictionary
  end
end
