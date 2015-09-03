class CategoriesController < ApplicationController

  def show
    @category = Category.find(params[:id])
    @category_videos = Video.where(category_id: @category.id)
  end

end
