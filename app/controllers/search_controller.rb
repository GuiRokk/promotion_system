class SearchController < ApplicationController
  def show
    query = params[:query]
    @coupon = Coupon.search(query)
    @promotions = Promotion.search(query)
    redirect_to promotions_path(query: query), notice: t('.failed') if @coupon.nil? && @promotions.empty?
    @coupon unless @coupon.nil?
    redirect_to promotions_path(query: query) unless @promotions.empty?
  end
end
