class PromotionsController < ApplicationController

  def index
    @promotions = Promotion.all
  end

  def show
    @promotion = Promotion.find(params[:id])
  end

  def new
    @promotion = Promotion.new
  end

  def create
    @promotion = Promotion.new(promotion_params)
    if @promotion.valid?
      @promotion.save
      redirect_to @promotion
    else
      render :new
    end
  end

  def edit
    @promotion = Promotion.find(params[:id])
  end

  def update
    @promotion = Promotion.find(params[:id]) 
    if @promotion.update(promotion_params)
      flash[:notice] = 'Promoção editada com sucesso'
      redirect_to @promotion
    else
      render :edit
    end
  end

  def generate_coupons
    @promotion = Promotion.find(params[:id])
    (1..@promotion.coupon_quantity).each do |number|
      Coupon.create(code: "#{@promotion.code}-#{'%04d' % number}", promotion: @promotion)
    end
    flash[:notice] = 'Cupons gerados com sucesso'
    redirect_to @promotion
  end

  def destroy
    @promotion = Promotion.find(params[:id])
    flash[:notice] = "Promoção #{@promotion.name} apagada com sucesso"
    @promotion.destroy
    redirect_to promotions_path
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
end