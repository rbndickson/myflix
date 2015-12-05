class VideosController < ApplicationController
  before_action :require_user

  def index
    @categories = Category.all
  end

  def show
    @video = Video.find(params[:id]).decorate
    @reviews = @video.reviews
  end

  def search
    @query = params[:query]
    @results = Video.search_by_title(@query)
  end

  def advanced_search
    @query = params[:query]
    if params[:query]
      @results = Video.search(@query).records.to_a
    else
      @results = []
    end
  end
end
