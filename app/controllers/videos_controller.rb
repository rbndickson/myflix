class VideosController < ApplicationController
  def index
    @categories = Category.all
  end

  def show
    @video = Video.find(params[:id])
  end

  def search
    @query = params[:query]
    @results = Video.search_by_title(@query)
  end
end
