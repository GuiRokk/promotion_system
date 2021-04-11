class Coupon < ApplicationRecord
  belongs_to :promotion

  enum status: { active: 0, disabled: 10, burned: 20 }
  delegate :discount_rate, :expiration_date, to: :promotion
  # delegate :product_categories, to :promotion

  def self.search(query)
    find_by(code: query)
  end

  def burn
    burned!
  end
end
