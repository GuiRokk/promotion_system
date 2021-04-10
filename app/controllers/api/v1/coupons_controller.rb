class Api::V1::CouponsController < Api::V1::ApiController
  def show
    @coupon = Coupon.find_by(code: params[:code])
    render json: @coupon.as_json(only: %i[code status],
                                 include: { promotion: { only: %i[name discount_rate
                                                                  expiration_date] } })
  end
end
