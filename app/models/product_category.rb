class ProductCategory < ApplicationRecord
  validates :name, :code, presence: {message: 'não pode ficar em branco'}

  validates :code, uniqueness: {message: 'deve ser único'}
end
