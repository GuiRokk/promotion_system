class ProductCategoriesController < ApplicationController

  def index
    @products = ProductCategory.all
  end

  def show
  @product = ProductCategory.find(params[:id])
  end
end
