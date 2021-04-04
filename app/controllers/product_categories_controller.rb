class ProductCategoriesController < ApplicationController
before_action :fetch_product, only: %i[show edit update destroy]
before_action :authenticate_user!

  def index
    @products = ProductCategory.all
  end

  def show
  end

  def new
    @product = ProductCategory.new
  end

  def create
    @product = ProductCategory.new(product_params)
    if @product.valid?
      @product.save
      redirect_to_show
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @product.update(product_params)
      flash[:notice] = t('.success')
      redirect_to_show
    else
      render :edit
    end
  end

  def destroy
    @product.delete
    flash[:notice] = t('.success', name: @product.name)
    redirect_to_index
  end

  private

  def product_params
    params.require(:product_category).permit(:name, :code)  
  end

  def fetch_product
    @product = ProductCategory.find(params[:id])
  end

  def redirect_to_show
    redirect_to @product
  end

  def redirect_to_index
    redirect_to product_categories_path
  end
end