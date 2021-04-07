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
end
