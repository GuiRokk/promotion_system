class Api::V1::PromotionsController < Api::V1::ApiController
  before_action :fetch_promotion, only: %i[show destroy]

  def show
    if @promotion
      render json: @promotion
    else
      render json: 'Atenção - Promoção Inexistente'
    end
  end

  def index
    @promotions = Promotion.all
    if @promotions.any?
      render json: @promotions.as_json(only: [:name]) unless @promotions.empty?
    else
      render json: 'Nada para mostrar - Não existem promoções cadastradas'
    end
  end

  def create
    @promotion = Promotion.new(promotion_params)
    if @promotion.save
      render json: @promotion
    else
      render json: @promotion.errors
    end
  end

  def destroy
    @promotion.destroy
    render json: "Promoção #{@promotion.name} apagada com sucesso"
  end
end

private

def fetch_promotion
  @promotion = Promotion.find_by(name: params[:name])
end

def promotion_params
  params.require(:promotion).permit(:name,
                                    :description,
                                    :code,
                                    :discount_rate,
                                    :coupon_quantity,
                                    :expiration_date,
                                    :user_id)
end
