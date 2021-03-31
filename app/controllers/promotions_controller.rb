class PromotionsController < ApplicationController
  before_action :authenticate_user!, only: %i[index show create generate_coupons]
  before_action :fetch_promotion, only: [:show, :edit, :update, :destroy, :generate_coupons, :approve]

  def index
    if params[:query].nil?
      @promotions = Promotion.all
    else
      @promotions = Promotion.search(params[:query])
    end
  end

  def show
  end

  def new
    @promotion = Promotion.new
  end

  def create
    #@promotion = Promotion.new(promotion_params) 
    #@promotion.user = current_user  #outra opção
    #Promotion.new(**promotions_params, user: current_user) -> Double splat operator (merge de cjaves para hash)
    @promotion = current_user.promotions.new(promotion_params)    #vem por causa do has_many
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
      flash[:notice] = t('.success')
      redirect_to_show
    else
      render :edit
    end
  end

  def generate_coupons
    @promotion.generate_coupons!
    flash[:notice] = t('.success')
    redirect_to_show
  end

  def destroy
    @promotion.destroy
    flash[:notice] = t('.success',promotion_name: @promotion.name)
    redirect_to_index
  end

  def approve
    PromotionApproval.create!(promotion: @promotion, user: current_user)
    redirect_to @promotion, notice: 'Promoção aprovada com sucesso'
  end

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
end