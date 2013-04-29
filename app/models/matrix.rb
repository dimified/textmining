class Matrix < ActiveRecord::Base

  def initialize
    save_lemma_text
  end

  def dictionary
    total_documents = Collection.all.size
    dictionary = Hash.new { |h, k| h[k] = 0 }
    treshold = 0.02

    Collection.all.each do |collection|
      collection.lemma.split.each do |token|
        dictionary[token] += 1
      end
    end

    dictionary.delete_if { |key, value| (value.to_f / total_documents) <  treshold } 
  end

  protected

  def save_lemma_text
    Collection.all.each do |collection|
      if collection.lemma.nil?
        text = ''
        collection.processed_text.each_key { |term| text << term + ' ' }
        collection.lemma = text.chop
        collection.save
      end
    end
  end
end
