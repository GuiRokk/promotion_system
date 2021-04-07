class PromotionsController < ApplicationController
  before_action :authenticate_user! # , only: %i[index show new create update destroy generate_coupons approve]
  before_action :fetch_promotion, only: %i[show edit update destroy generate_coupons approve]

  def index
    query = params[:query]
    if query == ''
      flash.now[:notice] = t('.show_all')
      @promotions = Promotion.all
    else
      @promotions = Promotion.search(query)
    end
  end

  def show; end

  def new
    @promotion = Promotion.new
  end

  def create
    # @promotion = Promotion.new(promotion_params)
    # @promotion.user = current_user  #outra opção
    # Promotion.new(**promotions_params, user: current_user) -> Double splat operator (merge de cjaves para hash)
    @promotion = current_user.promotions.new(promotion_params) # vem por causa do has_many
    if @promotion.save
      redirect_to_show
    else
      render :new
    end
  end

  def edit; end

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
    flash[:notice] = t('.success', promotion_name: @promotion.name)
    redirect_to_index
  end

  def approve
    if @promotion.can_approve?(current_user)
      # PromotionApproval.create!(promotion: @promotion, user: current_user)
      current_user.promotion_approvals.create!(promotion: @promotion)
      redirect_to @promotion, notice: t('.success')
    else
      redirect_to @promotion, notice: t('.failure')
    end
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

  # def can_be_approved
  # redirect_to @promotion
  # alert: 'nao pode fazer isso'
  # end

  # TODO: VER ISSO AQUI
end
