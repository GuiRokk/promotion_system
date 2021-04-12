class ProductCategory < ApplicationRecord
  has_many :promotion_categories, dependent: :restrict_with_error
  has_many :promotions, through: :promotion_categories

  validates :name, :code, presence: { message: 'não pode ficar em branco' }

  validates :code, uniqueness: { message: 'deve ser único' }

  def can_update?(params)
    params.key?(:name) &&
      params.key?(:code)
  end
end
