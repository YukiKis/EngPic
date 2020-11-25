class Admin::WordsController < ApplicationController
  before_action :authenticate_admin!
  before_action :setup, except: [:index, :search, :today]
  
  def index
    @words = Word.order("name").page(params[:page]).per(15)
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

  def search
    @q = Word.ransack(params[:q])
    @words = @q.result(distinct: true).page(params[:page]).per(15)
    render "index"
  end
  
  def today
    @q = Word.ransack(params[[:q]])
    @words = Word.today.page(params[:page]).per(15)
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
