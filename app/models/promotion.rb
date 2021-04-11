class Promotion < ApplicationRecord
  belongs_to :user
  has_many :coupons, dependent: :destroy # restrict_with_error
  has_one :promotion_approval, dependent: :destroy
  has_one :approver, through: :promotion_approval, source: :user
  # has_many :product_categories

  validates :name, :code, :discount_rate, :coupon_quantity, :expiration_date, presence: true

  validates :name, :code, uniqueness: true

  validate :expiration_date_cannot_be_in_the_past

  def generate_coupons!
    return if coupons?

    (1..coupon_quantity).each do |number|
      coupons.create!(code: "#{code}-#{format('%04d', number)}")
    end
  end

  def coupons?
    coupons.any?
  end

  def self.search(query)
    where('name LIKE ?', "%#{query}%") # .limit(5)
  end

  def approved?
    promotion_approval.present?
  end

  def self.approved
    joins(:promotion_approval)
  end

  def self.pending
    all - approved
  end

  def can_approve?(current_user)
    user != current_user
  end

  def can_delete?
    coupons.active.empty?
  end

  def can_update?(params)
    params.key?(:name) &&
      params.key?(:code) &&
      params.key?(:discount_rate) &&
      params.key?(:coupon_quantity) &&
      params.key?(:expiration_date)
  end

  private

  def expiration_date_cannot_be_in_the_past
    return unless expiration_date.present? && expiration_date < Date.current

    errors.add(:expiration_date, 'não pode ser no passado')
  end
end
