Fabricator(:coupon) do
  code { sequence(:code) + 1 }
  promotion
  status :active

  before_create do |coupon, _transient|
    coupon.code = "#{coupon.promotion.code}-#{format('%04d', code)}"
  end
end
