class TermMatrix < ActiveRecord::Base
  attr_accessible :term, :term_id

  def create_dictionary
    dictionary = []
    #models = ActiveRecord::Base.connection.tables.collect{|t| t.underscore.singularize.camelize}
    models = ['Challenge', 'Comment', 'Contribution']

    models.each do |model|
      model.constantize.all.each do |challenge|
        words = challenge.stop_words.split
        words.each do |word|
          unless dictionary.include?(word)
            dictionary.push(word)
          end
        end
      end
    end
    dictionary.sort
  end
end
