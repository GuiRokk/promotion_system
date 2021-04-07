Fabricator(:coupon) do
  code { sequence(:code) }
  promotion
  status :active

  before_create do |coupon, _transient|   # callback da gem
    coupon.code = "#{coupon.promotion.code}-#{format('%04d', (coupon.code.to_i + 1))}"
  end
end
