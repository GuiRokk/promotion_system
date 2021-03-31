class Promotion < ApplicationRecord
  belongs_to :user
  has_many :coupons, dependent: :destroy #restrict_with_error
  has_one :promotion_approval, dependent: :destroy
  has_one :approver, through: :promotion_approval, source: :user

  validates :name,:code, :discount_rate, :coupon_quantity,
            :expiration_date, presence: true

  validates :name, :code, uniqueness: true

  validate :expiration_date_cannot_be_in_the_past

  def generate_coupons!
    return if coupons?

    (1..coupon_quantity).each do |number|
        coupons.create!(code: "#{code}-#{'%04d' % number}")
    end
  end

  def coupons?
    coupons.any?
  end

  def self.search(query)
    where('name LIKE ?', "%#{query}%")#.limit(5)
  end

  def approved?
    promotion_approval.present?
  end

  #def can_approve?(current_user)
  #  user != current_user
  #end
  #TODO: ver aqui tbm
  private

  def expiration_date_cannot_be_in_the_past
    return unless expiration_date.present? && expiration_date < Date.current
      errors.add(:expiration_date, "não pode ser no passado")
  end
end