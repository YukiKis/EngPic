class Public::DictionariesController < ApplicationController
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
  
  def choose
    @tags = current_user.dictionary.words.tag_counts_on(:tags).map { |tag| tag.name }
  end
  
  def question
    if request.post?
      category = category_params[:tag]
      @questions = current_user.dictionary.words.tagged_with(category)[0..1]
    else
      @questions = current_user.words.all[0..1]
    end
    render "question"
  end
  
  def check
    questions = [answer_params[:question0], answer_params[:question1], answer_params[:question2], answer_params[:question3]].compact
    @questions = questions.map do |q|
      Word.find(q)
    end
    @questions.compact
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
      params.require(:check).permit(:answer1, :answer2, :answer3, :answer4, :question1, :question2, :question3, :question4)
    end
end
