class Public::DictionariesController < ApplicationController
  before_action :authenticate_user!
  before_action :setup
  
  def create
    current_user.create_dictionary
    redirect_to dictionary_path
  end
  
  def show
  end
  
  def words
    @words = @dictionary.words.all
    @word_count = @words.count
    render "public/words/index"
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
    @word = Word.find(params[:id])
    @dictionary.add(@word)
  end
  
  def remove
    @word = Word.find(params[:id])
    @dictionary.remove(@word)
  end
  
  private
    def setup
      @dictionary = current_user.dictionary
    end
    
    # def answer_params
      # params.require(:answer).permit(:answer)
    # end
end
