class ArticlesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :fetch_article, only: [:show, :edit, :update, :destroy]
  before_action :can_edit?, only: [:edit, :update, :destroy]

  def new
    @article = Article.new
  end

  def create
    @article = current_user.articles.new(article_params.merge(rating: (0..5).to_a.sample))

    if @article.save
      redirect_to dashboard_path
    else
      render :new
    end
  end

  def show; end

  def edit; end

  def update
    if @article.update(article_params)
      redirect_to article_path(@article)
    else
      render :edit
    end
  end

  def destroy
    if @article.destroy
      redirect_to dashboard_path
    else
      redirect_to :back, notice: 'Something went wrong'
    end
  end


  private

  def fetch_article
    @article = Article.find(params[:id])
  end

  def article_params
    params.require(:article).permit(:name_en, :name_ru, :text, :category_id, :cover)
  end

  def can_edit?
    fail 'You little hacker!' if current_user.nil? || Article.find(params[:id]).user_id != current_user.id
  end
end
