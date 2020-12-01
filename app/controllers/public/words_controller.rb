class Public::WordsController < ApplicationController
  before_action :authenticate_user!
  before_action :setup_word, only: [:show, :edit, :update, :destroy]
  before_action :setup_q_for_tag, only: [:tags, :tag_search]
  before_action :setup_q_for_word, only: [:index, :tagged_words, :search, :same_name, :same_meaning]
  before_action :ready_table, only: [:index, :tagged_words, :search, :same_name, :same_meaning]
  before_action :clear_session_q
  
  def index
    @words = Word.active.page(params[:page]).per(12)
    @word_count = Word.active.count
  end
  
  def tagged_words
    @words = Word.active.tagged_with(params[:tag]).page(params[:page]).per(12)
    @word_count = Word.active.tagged_with(params[:tag]).count
    @tag = params[:tag]
    render "index"
  end
  
  def show
    related_words = []
    @word.tag_list.each do |tag|
      Word.active.tagged_with(tag).sample(5).each do |w|
        if w == @word
        else
          related_words << w
        end
      end
    end
    @related_words = related_words.uniq.sample(4)
  end
  
  def new
    @title = "New"
    @word = Word.new
    @btn = "Create!"
  end
  
  def create
    params = word_params.except(:is_auto)
    @word = current_user.words.new(params)
    if @word.save
      if tags = Vision.get_image_data(@word.image) # vision apiからタグを持ってきて、問題ないとき
        if word_params[:is_auto] == "1"
          tags.each do |t|
            @word.tag_list << t
          end
          @word.save
          current_user.dictionary.add(@word)
          redirect_to word_path(@word)
        else
          current_user.dictionary.add(@word)
          redirect_to word_path(@word)          
        end
      else # safe searchに引っかかったとき
        @word.destroy
        redirect_to new_word_path, notice: "先ほどの画像は不適切なため投稿出来ません。"
      end
    else
      @title = "New"
      @btn = "Create!"
      render "new"
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
    params = word_params.except(:is_auto)
    if @word.update(params)
      if tags = Vision.get_image_data(@word.image) # vision apiからタグを持ってきて、問題ないとき
        if word_params[:is_auto] == "1"
          tags.each do |t|
            @word.tag_list << t
          end
          @word.save
          current_user.dictionary.add(@word)
          redirect_to word_path(@word)
        else
          current_user.dictionary.add(@word)
          redirect_to word_path(@word)          
        end
      else # safe searchに引っかかったとき
        @title = "Edit"
        @btn = "Update!"
        flash.now[:notice] = "先ほどの画像は不適切なため投稿出来ません。"
        render "edit"
      end
    else
      @title = "Edit"
      @btn = "Update!"
      render "edit"
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
    @words = @q.result(distinct: true).page(params[:page]).per(12)
    @word_count = @q.result(distinct: true).count
    @tag = params[:q][:name_or_meaning_start]
    render "index"
  end
  
  def same_name
    @words = Word.active.by_same_name(params[:name]).page(params[:page]).per(12)
    @word_count = Word.active.by_same_name(params[:name]).count
    @tag = params[:name]
    render "index"
  end
  
  def same_meaning
    @words = Word.active.by_same_meaning(params[:meaning]).page(params[:page]).per(12)
    @word_count = Word.active.by_same_meaning(params[:meaning]).count
    @tag = params[:meaning]
    render "index"
  end
  
  def tags
    @words = Word.active
    @tags = @words.tag_counts.page(params[:page]).per(12)
    @tag_count = @words.tag_counts.all.count
  end
  
  def tag_search
    @words = Word.active
    @tags = @q.result(distinct: true).page(params[:page]).per(12)
    @tag_count = @tags.count
    @tag = params[:q][:name_start]
    render "tags"
  end
  
  private
    def word_params
      params.require(:word).permit(:name, :meaning, :image, :sentence, :tag_list, :is_auto)
    end
    
    def is_auto_params
      params.require(:is_auto).permit(:true)
    end
    
    def setup_word
      @word = Word.find(params[:id])
      unless @word.user.is_active
        redirect_to request.referer || user_path(current_user), notice: "その単語はご覧いただけません。"
      end
    end
    
    def setup_q_for_tag
      @q = Word.active.tag_counts.ransack(params[:q])
    end
    
    def setup_q_for_word
      @q = Word.active.ransack(params[:q])
    end
    
    def word_new
      @word = Word.new
    end
    
    def ready_table
      listed_words = []
      @listed_words = []
      tags = []
      @tags = []
      meanings = []
      @meanings = []
      words = Word.active.sample(4)
      words.each do |w|
        listed_words << w.name
        w.tags.each { |t| tags << t.name }
        meanings << w.meaning
      end
      if tags
        @tags = tags.uniq.sample(4)
      end
      if meanings
        @meanings = meanings.uniq
      end
      if listed_words
        @listed_words = listed_words.uniq
      end
    end
end
