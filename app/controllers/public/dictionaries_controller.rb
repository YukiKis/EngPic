class Public::DictionariesController < ApplicationController
  before_action :authenticate_user!
  before_action :setup
  before_action :setup_q_for_tag, only: [:tags, :tag_search]
  before_action :setup_q_for_word, only: [:show, :tagged_words, :search]
  before_action :clear_session_q
  def show    
    @words = @active_words_in_dictionary.page(params[:page]).per(12)
    @tags = @active_words_in_dictionary.tag_counts.sort_by { |t| t.name }[0..9]
  end
  
  def tags
    @tags = @active_words_in_dictionary.tag_counts.page(params[:page]).per(12)
    @tag_count = @active_words_in_dictionary.tag_counts.count
  end
  
  def tag_search
    @tags = @q.result(distinct: true).page(params[:page]).per(12)
    @tag_count = @tags.count
    render "tags"
  end
    
  
  def tagged_words
    @words = @active_words_in_dictionary.tagged_with(params[:tag]).page(params[:page]).per(12)
    @tags = @active_words_in_dictionary.tag_counts.sort_by { |t| t.name }[0..9]
    @word_count = @active_words_in_dictionary.tagged_with(params[:tag]).count
    @tag = params[:tag]
    render "show"
  end
  
  def choose
    @tags = current_user.dictionary.words.active.tag_counts_on(:tags).map { |tag| tag.name }
  end
  
  def question
    if request.post?
      @questions = current_user.dictionary.words.active.tagged_with(category_params[:tag]).sample(4)
    else
      @questions = current_user.dictionary.words.active.sample(4)
    end
  end
  
  def check
    if request.post?
      questions = [answer_params[:question0], answer_params[:question1], answer_params[:question2], answer_params[:question3]].compact
      @questions = questions.map do |q|
      Word.find(q)
      end
      @answers =[ answer_params[:answer0], answer_params[:answer1], answer_params[:answer2], answer_params[:answer3]].compact
      @rights = 0
      @questions.each_with_index do |q, i|
        if @answers[i] == q.name
          @rights += 1
        end
      end
      render "result"
    else
      redirect_to choose_dictionary_path, notice: "エラーが発生したため、選択画面に戻りました。"
    end
  end
  
  def search
    @words = @q.result.page(params[:page]).per(12)
    @tags = @active_words_in_dictionary.tag_counts.sort_by { |t| t.name }[0..9]
    @tag = params[:q][:name_or_meaning_start]
    @word_count = @q.result.count
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
      @active_words_in_dictionary = @dictionary.words.active
    end
    
    def setup_q_for_tag
      @q = @active_words_in_dictionary.tag_counts.ransack(params[:q])
    end
    
    def setup_q_for_word
      @q = @active_words_in_dictionary.ransack(params[:q])
    end

    def category_params
      params.require(:category).permit(:tag)
    end
    def answer_params
      params.require(:check).permit(:answer0, :answer1, :answer2, :answer3, :question0, :question1, :question2, :question3)
    end
end
