lass Public::DictionariesController < ApplicationController
  before_action :authenticate_user!
  before_action :setup
  
  def show
  end
  
  def words
    @q = Word.ransack(params[:q])
    @words = @dictionary.words.all
    @word_count = @words.count
    render "public/words/index"
  end
  
  def choo
    @tags = Word.tag_counts.map { |tag| tag.name }
  end
  
  def question
    if request.post?
      category = category_params[:tag]
      @questions = Word.tagged_with(category)[0..1]
    else
      @questions = Word.all[0..1]
    end
    render "question"
  end
  
  def check
    questions = answers = []
    questions << [ answer_params[:question0], answer_params[:question1], answer_params[:question2], answer_params[:question3]]
    answers << [ answer_params[:answer0], answer_params[:answer1], answer_params[:answer2], answer_params[:answer3]]
    @right = 0
    questions.each do |q|
      answers.each do |a|
        if q == a
          @right += 1
        end
      end
    end
    render "result"
       
  end

  def add
    @word = Word.find(params[:id])
    @dictionary.add(@word)
    render "add.js.erb"
  end
  
  def remove
    @word = Word.find(params[:id])
    @dictionary.remove(@word)
  end
  
  private
    def setup
      @dictionary = current_user.dictionary
    end
    
    def category_params
      params.require(:category).permit(:tag)
    end
    def answer_params
      params.require(:check).permit(:"0", :"1", :"2", :"3", :question0, :question1, :question2, :question3)
    end
end
