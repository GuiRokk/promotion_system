class Promotion < ApplicationRecord
  has_many :coupons, dependent: :destroy

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

  private

  def expiration_date_cannot_be_in_the_past
    return unless expiration_date.present? && expiration_date < Date.current
      errors.add(:expiration_date, "não pode ser no passado")
  end
end