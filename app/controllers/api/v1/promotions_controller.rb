class Api::V1::PromotionsController < Api::V1::ApiController
  before_action :fetch_promotion, only: %i[show update destroy]

  def show
    render :show
  end

  def index
    @promotions = Promotion.all
    raise ActiveRecord::RecordNotFound unless @promotions.any?

    render json: @promotions
  end

  def create
    @promotion = Promotion.create!(promotion_params)
    render :show, status: :created
  end

  def update
    raise ActiveRecord::RecordInvalid unless @promotion.can_update?(promotion_params)

    @promotion.update!(promotion_params)
    render :show
  end

  def destroy
    raise ActiveRecord::RecordNotDestroyed unless @promotion.can_delete?

    @promotion.destroy!
    render json: "Promoção #{@promotion.name} apagada com sucesso", status: :no_content
  end
end

private

def fetch_promotion
  @promotion = Promotion.find_by!(name: params[:name])
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
