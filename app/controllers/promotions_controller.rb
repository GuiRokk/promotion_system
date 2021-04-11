class PromotionsController < ApplicationController
  before_action :authenticate_user!
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
    return unless @promotion.can_update?(promotion_params)

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
    if @promotion.can_delete?
      @promotion.destroy
      flash[:notice] = t('.success', promotion_name: @promotion.name)
      redirect_to_index
    else
      flash[:notice] = t('.failed')
      redirect_to_show
    end
  end

  def approve
    if @promotion.can_approve?(current_user)
      current_user.promotion_approvals.create!(promotion: @promotion)
      PromotionMailer
        .with(promotion: @promotion, approver: current_user)
        .approval_email
        .deliver_now
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
end
