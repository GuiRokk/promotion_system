class Api::V1::PromotionsController < Api::V1::ApiController

	def show
		@promotion =  Promotion.find_by(name: params[:name])
		if @promotion
			render json: @promotion
		else
			render json: "Atenção - Promoção Inexistente"
		end
	end


	def index
		@promotions = Promotion.all
		if @promotions.any?
			render json: @promotions.as_json(only:[:name]) unless @promotions.empty?
		else
			render json: 'Nada para mostrar - Não existem promoções cadastradas'
		end
	end


	def create
		@promotion = Promotions.new(promotion_params)
    if @promotion.save
      render json: @promotion
    else
      render json: @promotion.errors
    end
	end
end


private

  def promotion_params
    params.require(:promotion, :user).permit(:name,
                                      :description,
                                      :code,
                                      :discount_rate,
                                      :coupon_quantity,
                                      :expiration_date, :user_id)