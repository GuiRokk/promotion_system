class ProductCategoriesController < ApplicationController

  def index
    @products = ProductCategory.all
  end

  def show
    fetch_product
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
    fetch_product
  end

  def update
    fetch_product
    if @product.update(product_params)
      flash_notice_message('update')
      redirect_to_show
    else
      render :edit
    end
  end

  def destroy
    fetch_product
    @product.delete
    flash_notice_message('delete')
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

  def flash_notice_message(action)
    case action
      when 'update'
        message = 'Produto editado com sucesso'
      when 'delete'
        message = "Produto #{@product.name} apagado com sucesso"
    end
    flash[:notice] = message
  end
end