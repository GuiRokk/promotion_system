require "test_helper"

class CouponTest < ActiveSupport::TestCase
  test 'search coupon by exact code successfuly' do
    user = User.create!(email: 'test@iugu.com.br', password: '123123', name: 'Fulano')
    promotion = Promotion.create!(name: 'Natal',
                                  description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, 
                                  coupon_quantity: 2,
                                  expiration_date: '22/12/2033', user: user)
    coupon1 = Coupon.create!(code: 'NATAL10-0001', promotion: promotion)
    coupon2 = Coupon.create!(code: 'NATAL10-0002', promotion: promotion)

    result = Coupon.search(coupon1.code)

    assert_equal result, coupon1
    refute_equal result, coupon2
  end

  test 'search coupon finds nothing' do
    user = User.create!(email: 'test@iugu.com.br', password: '123123', name: 'Fulano')
    promotion = Promotion.create!(name: 'Natal',
                                  description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, 
                                  coupon_quantity: 2,
                                  expiration_date: '22/12/2033', user: user)
    coupon1 = Coupon.create!(code: 'NATAL10-0001', promotion: promotion)
    coupon2 = Coupon.create!(code: 'NATAL10-0002', promotion: promotion)

    result = Coupon.search('CYBER')

    assert_nil result
  end
end
