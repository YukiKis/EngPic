class Admin::WordsController < ApplicationController
  before_action :authenticate_admin!
  before_action :setup, except: [:index, :search]
  
  def index
    @words = Word.page(params[:page]).per(20)
    @q = Word.ransack(params[:q])
  end

  def show
  end

  def edit
  end
  
  def update
    if @word.update(word_params)
      redirect_to admin_word_path(@word)
    else
      render "edit"
    end
  end

  def new
  end
  
  def search
    @q = Word.ransack(params[:q])
    @words = @q.result(distinct: true).page(params[:page]).per(20)
    render "index"
  end
  
  private
    def setup
      @word = Word.find(params[:id])
    end
    
    def word_params
      params.require(:word).permit(:name, :meaning, :sentence, :image, :tag_list)
    end
end
