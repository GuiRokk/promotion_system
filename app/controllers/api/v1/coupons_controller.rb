class Api::V1::CouponsController < Api::V1::ApiController
  def show
    @coupon = Coupon.active.find_by!(code: params[:code])
  end

  def burn
    @coupon = Coupon.find_by!(code: params[:code])
    @coupon.burn
    render json: @coupon
  end
end

# TODO: VAI TER MAIS CONTEUDO DO CARD #21 (REQUER, CARDS 18, 22)
