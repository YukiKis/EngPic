class Public::WordsController < ApplicationController
  before_action :authenticate_user!, except: :index
  before_action :get_word, only: [:show, :edit, :update, :destroy]
  before_action :ready_table, only: [:index, :tagged_words, :search, :same_name, :same_meaning]

  def index
    @q = Word.ransack(params[:q])
    @words = Word.page(params[:page]).per(12)
    @word_count = Word.all.count
  end
  
  def tagged_words
    @q = Word.ransack(params[:q])
    @words = Word.tagged_with(params[:tag]).page(params[:page]).per(12)
    @word_count = @words.count
    @tag = "'#{ params[:tag] }' "
    render "index"
  end
  
  def show
    @related_words = []
    # if @word.tag_list.any?
    #   @word.tag_list.each do |tag|
    #     @related_words = Word.tagged_with(tag)
    # end
    @word.tag_list.each do |tag|
      Word.tagged_with(tag).sample(5).each do |w|
        if w == @word
        else
          @related_words << w
        end
      end
    end
    if @related_words.present?
      @related_words.uniq.sample(4)
    end
  end
  
  def new
    @title = "New"
    @word = Word.new
    @btn = "Create!"
    render "edit"
  end
  
  def create
    @word = current_user.words.new(word_params)
    if @word.save
      current_user.dictionary.add(@word)
      redirect_to word_path(@word)
    else
      @title = "New"
      @btn = "Create!"
      render "edit"
    end
  end
  
  def edit
    if current_user == @word.user
      @title = "Edit"
      @btn = "Update!"
    else
      redirect_to word_path(@word)
    end
  end
  
  def update
    session[:image] = word_params[:image]
    debugger
    if @word.user != current_user
      redirect_to word_path(@word)
    else
      if @word.update(word_params)
        redirect_to word_path(@word)
      else
        @title = "Edit"
        @btn = "Update!"
        render "edit"
      end
    end
  end
  
  def destroy
    if @word.user != current_user
      redirect_to word_path(@word)
    else
      user = @word.user
      @word.destroy
      redirect_to user_path(user)
    end
  end
  
  def search
    @q = Word.ransack(params[:q])
    @words = @q.result(distinct: true).page(params[:page]).per(12)
    @word_count = @words.count
    render "index"
  end
  
  def same_name
    @q = Word.ransack(params[:q])
    @words = Word.by_same_name(params[:name]).page(params[:page]).per(12)
    @word_count = @words.count
    render "index"
  end
  
  def same_meaning
    @q = Word.ransack(params[:q])
    @words = Word.by_same_meaning(params[:meaning]).page(params[:page]).per(12)
    @word_count = @words.count
    render "index"
  end
  
  def tags
    @q = Word.tag_counts.ransack(params[:q])
    @tags = Word.tag_counts.page(params[:page]).per(12)
    @tag_count = Word.tag_counts.all.count
  end
  
  def tag_search
    @q = Word.tag_counts.ransack(params[:q])
    @tags = @q.result(distinct: true).page(params[:page]).per(12)
    @tag_count = @tags.count
    render "tags"
  end
  
  private
    def word_params
      params.require(:word).permit(:name, :meaning, :image, :sentence, :tag_list)
    end
    
    def get_word
      @word = Word.find(params[:id])
    end
    
    def word_new
      @word = Word.new
    end
    
    def ready_table
      @listed_words = []
      @tags = []
      @meanings = []
      Word.all.each do |w|
        @listed_words << w.name
        @tags << w.tag_list
        @meanings << w.meaning
      end
      @listed_words.uniq!
      @tags.uniq
      @meanings.uniq!
    end
end
