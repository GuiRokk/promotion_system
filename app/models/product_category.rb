class ProductCategory < ApplicationRecord
  validates :name, :code, presence: { message: 'não pode ficar em branco' }

  validates :code, uniqueness: { message: 'deve ser único' }

  # belongs_to :promotions

  def can_update?(params)
    params.key?(:name) &&
      params.key?(:code)
  end
end
