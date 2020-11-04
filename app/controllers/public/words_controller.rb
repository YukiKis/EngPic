class Public::WordsController < ApplicationController
  before_action :authenticate_user!, except: :index
  before_action :get_word, only: [:show, :edit, :update, :destroy]

  def index
    @q = Word.ransack(params[:q])
    @words = Word.all
    @word_count = @words.count
  end
  
  def tagged_words
    @q = Word.ransack(params[:q])
    @words = Word.tagged_with(params[:tag])
    @word_count = @words.count
    render "index"
  end
  
  def show
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
      render "edit"
    end
  end
  
  def edit
    @title = "Edit"
    @btn = "Update!"
  end
  
  def update
    if @word.user != current_user
      redirect_to word_path(@word)
    else
      if @word.update(word_params)
        redirect_to word_path(@word)
      else
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
    @words = @q.result(distinct: true)
    @word_count = @words.count
    render "index"
  end
  
  private
    def word_params
      params.require(:word).permit(:name, :meaning, :image, :sentence, :tag_list)
      # params: :status
    end
    
    def get_word
      @word = Word.find(params[:id])
    end
    
    def word_new
      @word = Word.new
    end
end
