class Api::V1::ProductCategoriesController < Api::V1::ApiController
  before_action :fecth_product_category, only: %i[show update destroy]

  def show
    @product = ProductCategory.find_by!(code: params[:code])
    render json: @product
  end

  def index
    @products = ProductCategory.all
    render json: @products unless @products.empty?
  end

  def create
    @product = ProductCategory.create!(product_category_params)
    render json: @product
  end

  def update
    raise ActiveRecord::RecordInvalid unless @product.can_update?(product_category_params)

    @product.update!(product_category_params)
    render json: @product
  end

  def destroy
    @product.destroy!
  end
end

private

def product_category_params
  params.require(:product_category).permit(:name, :code)
end

def fecth_product_category
  @product = ProductCategory.find_by!(code: params[:code])
end
