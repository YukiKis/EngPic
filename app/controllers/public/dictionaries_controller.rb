class Public::DictionariesController < ApplicationController
  before_action :authenticate_user!
  before_action :setup
  
  def show
  end
  
  def choose
  end
  
  def question
    # @questions = 
  end
  
  def check
  end
  
  def result
  end
  
  def add
    @dictionary.add(Word.find(params[:id]))
    redirect_to word_path(@word)
  end
  
  def remove
    @dictionary.remove(Word.find(params[:id]))
    redirect_to word_path(@word)
  end
  
  private
    def setup
      @dictionary = current_user.dictionary
    end
    
    # def answer_params
      # params.require(:answer).permit(:answer)
    # end
end
