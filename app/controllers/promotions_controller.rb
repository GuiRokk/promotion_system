class PromotionsController < ApplicationController
  before_action :fetch_promotion, only:[:show, :edit, :update, :destroy, :generate_coupons]
  
  def index
    @promotions = Promotion.all
  end

  def show
  end

  def new
    @promotion = Promotion.new
  end

  def create
    @promotion = Promotion.new(promotion_params)
    if @promotion.save
      redirect_to_show
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @promotion.update(promotion_params)
      flash_notice_message('promo_update')
      redirect_to_show
    else
      render :edit
    end
  end

  def generate_coupons
    @promotion.generate_coupons!
    flash_notice_message('gen_coupon')
    redirect_to_show
  end

  def destroy
    flash_notice_message('promo_delete')
    @promotion.destroy
    redirect_to_index
  end

  #--------------------------------------------------------
  private

  def promotion_params
    params.require(:promotion).permit(:name, 
                                      :description, 
                                      :code, 
                                      :discount_rate, 
                                      :coupon_quantity, 
                                      :expiration_date)
  end

  def fetch_promotion
    @promotion = Promotion.find(params[:id])
  end

  def redirect_to_show
    redirect_to @promotion
  end

  def redirect_to_index
    redirect_to promotions_path
  end

  def flash_notice_message(action)
    case action
      when 'promo_update'
        message = 'Promoção editada com sucesso'
      when 'gen_coupon'
        message = 'Cupons gerados com sucesso'
      when 'promo_delete'
        message = "Promoção #{@promotion.name} apagada com sucesso"
    end
    flash[:notice] = message
  end

end