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

  def edit
    @product = ProductCategory.find(params[:id])
  end

  def update
    @product = ProductCategory.find(params[:id])
    if @product.update(product_params)
      flash[:notice] = 'Produto editado com sucesso'
      redirect_to @product
    else
      render :edit
    end
  end


  def destroy
    @product = ProductCategory.find(params[:id])
    @product.delete
    flash[:notice] = "Produto #{@product.name} apagado com sucesso"
    redirect_to product_categories_path
  end

  private

  def product_params
    params.require(:product_category).permit(:name, :code)  
  end
end
