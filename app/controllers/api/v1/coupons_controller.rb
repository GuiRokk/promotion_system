class Api::V1::CouponsController < Api::V1::ApiController

  def show
    @coupon = Coupon.active.find_by!(code: params[:code])
  end
end