class CouponsController < ApplicationController
  def disable
    @coupon = Coupon.find(params[:id])
    @coupon.disabled!
    redirect_to @coupon.promotion, notice: t('.success', coupon_code: @coupon.code)
  end

  def enable
    @coupon = Coupon.find(params[:id])
    @coupon.active!
    redirect_to @coupon.promotion, notice: t('.success', coupon_code: @coupon.code)
  end


  def show
    @coupons = Coupon.all
  end
  
  def search
    @coupons = Coupon.where('code = ?',params[:query])  #busca exata
    #@coupons = Coupon.where('code like ?',"%#{params[:name]}%") #usca genrérica
    if @coupons.any?
        @coupons
    else
        flash[:notice] = t('not_found')
        redirect_to promotions_path
    end
  end
end