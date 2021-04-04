class SearchController < ApplicationController
  def show
    @coupon = Coupon.search(params[:query])
    @promotions = Promotion.search(params[:query])
    if @promotions.empty?
      if @coupon.nil?
        flash[:notice] = t('.failed')
        redirect_to promotions_path(query: params[:query])
      else
        @coupon
      end
    else
      redirect_to promotions_path(query: params[:query])
    end
  end
end