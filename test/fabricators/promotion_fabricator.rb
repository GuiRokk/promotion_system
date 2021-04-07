Fabricator(:promotion) do
  name 'Natal'
  description 'Promoção de Natal'
  # code { sequence:(code) |i| "NATAL#{i}"}
  discount_rate 10
  coupon_quantity 3
  expiration_date '22/12/2033'
  user user
end
