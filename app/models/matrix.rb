class Matrix < ActiveRecord::Base

  def initialize
    save_lemma_text
  end

  def vectors
    vector = []
    $record_set.each do |collection|
      vector << collection.document_vector
    end
    vector
  end

  def dictionary
    dictionary = Hash.new { |h, k| h[k] = [0, 0] }
    treshold = 0.1

    $record_set.each do |collection|
      collection.lemma.split.each do |tab|
        dictionary[tab][0] += 1
      end
      collection.lemma.split.uniq.each do |tab|
        dictionary[tab][1] += 1
      end
    end

    dictionary.delete_if { |key, value| (value[1].to_f / $record_size) < treshold } 
  end

  protected

  def save_lemma_text
    $record_set.all.each do |collection|
      if collection.lemma.nil?
        text = ''
        collection.processed_text.each { |term| text << term + ' ' }
        collection.lemma = text.chop
        collection.save
      end
    end
  end
end
