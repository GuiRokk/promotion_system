class SearchController < ApplicationController
  def show
    query = params[:query]
    @coupon = Coupon.search(query)
    @promotions = Promotion.search(query)
    if @promotions.empty?
      if @coupon.nil?
        flash[:notice] = t('.failed')
        redirect_to promotions_path(query: query)
      else
        @coupon
      end
    else
      redirect_to promotions_path(query: query)
    end
  end
end
