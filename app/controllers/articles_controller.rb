class ArticlesController < ApplicationController
  before_filter :require_login, :except => [:index, :show]
  
  def index
    @articles = Article.all
  end

  def show
    @article = Article.find(params[:id])
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(params[:article])

    @article.save

    redirect_to article_path(@article), :notice => "@article.title created!"
  end

  def destroy
    @article = Article.find(params[:id])

    @article.destroy

    redirect_to articles_path, :notice => "@article.title deleted!"
  end

  def edit
    @article = Article.find(params[:id])
  end

  def update
    @article = Article.find(params[:id])
    @article.update_attributes(params[:article])

    redirect_to article_path(@article), :notice => "@article.title updated!"
  end
end
