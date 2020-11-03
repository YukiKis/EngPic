class Public::DictionariesController < ApplicationController
  before_action :authenticate_user!
  
  def show
    @dictionary = current_user.dictionary
  end
  
  def question
    @dictionary = current_user.dictionary
  end
  
  def check
  end
  
  def result
  end
  
  def add
    @word = Word.find(params[:id])
    current_user.dictionary.items.create(word: @word)
    redirect_to word_path(@word)
  end
  
  def remove
    @word = Word.find(params[:id])
    current_user.dictionary.items.find_by(word: @word).destroy
    redirect_to word_path(@word)
  end
  
end
