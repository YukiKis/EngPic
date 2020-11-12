class HomesController < ApplicationController
  def top
    if Word.all.present? 
      @words = []
      @tags = []
      @meanings = []
      Word.all.each do |w|
        @words << w.name
        @tags << w.tag_list
        @meanings << w.meaning
      end
      @words.uniq!
      @tags.flatten!.uniq!
      @meanings.uniq!
    end
  end

  def about
  end

  def howto
  end
end
