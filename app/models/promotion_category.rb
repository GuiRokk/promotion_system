class PromotionCategory < ApplicationRecord
  belongs_to :promotion
  belongs_to :product_category
end