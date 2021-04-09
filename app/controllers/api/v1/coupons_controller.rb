class Api::V1::CouponsController < Api::V1::ApiController
	def show
		@coupon = Coupon.find_by(code: params[:code])
		render json: @coupon.as_json(only: [:code, :status],
																include: {promotion: {only: [:name, :discount_rate, :expiration_date]}})
	end
end