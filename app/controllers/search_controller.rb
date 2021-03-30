class SearchController < ApplicationController
  def show
    @coupon = Coupon.search(params[:query])
    @promotions = Promotion.search(params[:query])

    if @promotions.empty?
      if @coupon.nil?
        flash[:notice] = 'Item buscado não encontrado'
        redirect_to promotions_path
      else
        @coupon
      end
    else
      render 'promotions/index'
    end
  end
end