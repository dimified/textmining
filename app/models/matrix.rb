class Matrix < ActiveRecord::Base
  attr_accessible :term, :term_id

  def dictionary
    # hash map is twice as faster than saving directly to array
    hash = Hash.new { |h, k| h[k] = [] }

    #models = ActiveRecord::Base.connection.tables.collect{|t| t.underscore.singularize.camelize}
    #models = ['Challenge', 'Comment', 'Contribution']

    # generate hash map for all entries
    Challenge.all.each do |clas|
      clas.processed_text.each_key do |key|
        unless hash[key[0]].include?(key)
          hash[key[0]] << key
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
