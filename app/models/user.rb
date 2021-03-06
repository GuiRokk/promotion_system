class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :promotions, dependent: :destroy
  has_many :promotion_approvals, dependent: :nullify
  has_many :approved_promotions, through: :promotion_approvals, source: :promotion

  # def approved_promotions
  # Promotion.joins(:promotion_approval).where(promotion_approvals: {user: self})
  # end
end
