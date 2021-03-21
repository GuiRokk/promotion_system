class ProductCategoriesController < ApplicationController

  def index
    @products = ProductCategory.all
  end

  def show
  @product = ProductCategory.find(params[:id])
  end

  def new
    @product = ProductCategory.new
  end

  def create
    @product = ProductCategory.new(product_params)
    if @product.valid?
      @product.save
      redirect_to @product
    else
      render :new
    end
  end


  private

  def product_params
    params.require(:product_category).permit(:name, :code)  
  end
end
