class Public::DictionariesController < ApplicationController
  before_action :authenticate_user!
  before_action :setup
  
  def show    
    @q = Word.ransack(params[:q])
    @words = @dictionary.words.page(params[:page]).per(12)
    @word_count = @words.count
  end
  
  def choose
    @tags = current_user.dictionary.words.tag_counts_on(:tags).map { |tag| tag.name }
  end
  
  def question
    if request.post?
      category = category_params[:tag]
      @questions = current_user.dictionary.words.tagged_with(category).sample(4)
    else
      @questions = current_user.dictionary.words.all.sample(4)
    end
    render "question"
  end
  
  def check
    questions = [answer_params[:question0], answer_params[:question1], answer_params[:question2], answer_params[:question3]].compact
    @questions = questions.map do |q|
      Word.find(q)
    end
    @answers =[ answer_params[:answer0], answer_params[:answer1], answer_params[:answer2], answer_params[:answer3]].compact
    @rights = 0
    @questions.each do |q|
      @answers.each do |a|
        if q.name == a
          @rights += 1
        end
      end

    end
    render "result"
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
    
    def category_params
      params.require(:category).permit(:tag)
    end
    def answer_params
      params.require(:check).permit(:answer0, :answer1, :answer2, :answer3, :question0, :question1, :question2, :question3)
    end
end
