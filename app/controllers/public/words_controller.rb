class Public::WordsController < ApplicationController
  before_action :authenticate_user!, except: :index
  before_action :get_word, only: [:show, :edit, :update, :destroy]

  def index
    @words = Word.all
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
  
  private
    def word_params
      params.require(:word).permit(:name, :meaning, :image, :sentence, :status)
    end
    
    def get_word
      @word = Word.find(params[:id])
    end
    
    def word_new
      @word = Word.new
    end
end
