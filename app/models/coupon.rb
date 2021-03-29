class Coupon < ApplicationRecord
  belongs_to :promotion

  enum status: { active: 0, disabled: 10 }

  def self.search(search)
    if search
      promotion = Promotion.find_bt(name: search)
      if promotion
        self.where(promotion_id: promotion)
      else
        Coupon.all
      end
    else
      Promotion.all
    end
  end


end