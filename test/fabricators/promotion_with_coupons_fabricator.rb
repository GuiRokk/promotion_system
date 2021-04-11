Fabricator(:promotion_with_coupons, from: :promotion) do
  # name { sequence(:name) { |i| "Natal#{i}" } }
  # description 'Promoção de Natal'
  # code { sequence(:code) { |i| "NATAL#{i}" } }
  # discount_rate 10
  # coupon_quantity 5
  # expiration_date '22/12/2033'
  # user
  coupons(count: 1)
end
