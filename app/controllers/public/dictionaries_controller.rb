class Public::DictionariesController < ApplicationController
  before_action :authenticate_user!
  before_action :setup
  
  def show    
    @q = @dictionary.words.ransack(params[:q])
    @words = @dictionary.words.page(params[:page]).per(12)
    @tags = @dictionary.words.tag_counts.sort_by { |t| t.name }[0..9]
  end
  
  def tags
    @q = @dictionary.words.tag_counts.ransack(params[:q])
    @tags = @dictionary.words.tag_counts.page(params[:page]).per(12)
    @tag_count = @dictionary.words.tag_counts.count
  end
  
  def tag_search
    @q = @dictionary.words.tag_counts.ransack(params[:q])
    @tags = @q.result(distinct: true).page(params[:page]).per(12)
    @tag_count = @tags.count
    render "tags"
  end
    
  
  def tagged_words
    @q = @dictionary.words.ransack(params[:q])
    @words = @dictionary.words.tagged_with(params[:tag]).page(params[:page]).per(12)
    @tags = @dictionary.words.tag_counts.sort_by { |t| t.name }[0..9]
    @word_count = @dictionary.words.tagged_with(params[:tag]).count
    @tag = "'#{ params[:tag] }' "
    render "show"
  end
  
  def choose
    @tags = current_user.dictionary.words.tag_counts_on(:tags).map { |tag| tag.name }
  end
  
  def question
    if request.post?
      @questions = current_user.dictionary.words.tagged_with(category_params[:tag]).sample(4)
    else
      @questions = current_user.dictionary.words.all.sample(4)
    end
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
  
  def search
    @q = @dictionary.words.ransack(params[:q])
    @words = @q.result.page(params[:page]).per(12)
    render "show"
  end
    

  def add
    @word = Word.find(params[:id])
    @dictionary.add(@word)
    render "add.js.erb"
  end
  
  def remove
    @word = Word.find(params[:id])
    @dictionary.remove(@word)
    render "remove.js.erb"
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
