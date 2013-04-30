class Matrix < ActiveRecord::Base

  def initialize
    save_lemma_text
  end

  def dictionary
    total_documents = Collection.all.size
    dictionary = Hash.new { |h, k| h[k] = [0, 0] }
    treshold = 0.1

    Collection.all.each do |collection|
      collection.lemma.split.each do |tab|
        dictionary[tab][0] += 1
      end
      collection.lemma.split.uniq.each do |tab|
        dictionary[tab][1] += 1
      end
    end

    dictionary.delete_if { |key, value| (value[1].to_f / total_documents) < treshold } 
  end

  protected

  def save_lemma_text
    Collection.all.each do |collection|
      if collection.lemma.nil?
        text = ''
        collection.processed_text.each { |term| text << term + ' ' }
        collection.lemma = text.chop
        collection.save
      end
    end
  end
end
