class Matrix < ActiveRecord::Base
  attr_accessible :term, :term_id

  def dictionary
    hash = Hash.new { |h, k| h[k] = [] }

    # generate hash map for all entries
    Collection.limit(20).each do |document|
      document.processed_text.each_key do |key|
        unless hash[key[0]].include?(key)
          hash[key[0]] << key
        end
      end
    end
  end
end
