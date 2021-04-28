require 'test_helper'

class PromotionTest < ActiveSupport::TestCase
  test 'attributes cannot be blank' do
    promotion = Promotion.new

    assert_not promotion.valid?
    assert_includes promotion.errors[:name], 'não pode ficar em branco'
    assert_includes promotion.errors[:code], 'não pode ficar em branco'
    assert_includes promotion.errors[:discount_rate], 'não pode ficar em '\
                                                      'branco'
    assert_includes promotion.errors[:coupon_quantity], 'não pode ficar em'\
                                                        ' branco'
    assert_includes promotion.errors[:expiration_date], 'não pode ficar em'\
                                                        ' branco'
  end

  test 'code must be unique' do
    other_promotion = Fabricate(:promotion)
    promotion = Promotion.new(code: other_promotion.code)

    assert_not promotion.valid?
    assert_includes promotion.errors[:code], 'já está em uso'
  end

  test 'name must be unique' do
    user = User.create!(email: 'test@iugu.com.br', password: '123123', name: 'Fulano')
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10,
                      coupon_quantity: 2, expiration_date: '22/12/2033', user: user)
    promotion = Promotion.new(name: 'Natal')

    assert_not promotion.valid?
    assert_includes promotion.errors[:name], 'já está em uso'
  end

  test 'generate coupons successfully' do
    user = User.create!(email: 'test@iugu.com.br', password: '123123', name: 'Fulano')
    promotion = Promotion.create!(name: 'Natal',
                                  description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10,
                                  coupon_quantity: 2,
                                  expiration_date: '22/12/2033', user: user)

    promotion.generate_coupons!

    assert promotion.coupons.size == promotion.coupon_quantity
  end

  test "generate coupons can't be called twice" do
    user = User.create!(email: 'test@iugu.com.br', password: '123123', name: 'Fulano')
    promotion = Promotion.create!(name: 'Natal',
                                  description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10,
                                  coupon_quantity: 2,
                                  expiration_date: '22/12/2033', user: user)

    promotion.generate_coupons!

    assert_no_difference 'Coupon.count' do
      promotion.generate_coupons!
    end
  end

  test 'search promotion successfuly' do
    user = User.create!(email: 'test@iugu.com.br', password: '123123', name: 'Fulano')
    xmas = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                             code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                             expiration_date: '22/12/2033', user: user)
    cyber = Promotion.create!(name: 'Cyber Monday', description: 'Promoção de Cyber Monday',
                              code: 'CYBER15', discount_rate: 15, coupon_quantity: 90,
                              expiration_date: '22/12/2033', user: user)

    result = Promotion.search('Natal')
    assert_includes result, xmas
    assert_not_includes result, cyber
  end

  test 'search promotion partial' do
    user = User.create!(email: 'test@iugu.com.br', password: '123123', name: 'Fulano')
    xmas = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                             code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                             expiration_date: '22/12/2033', user: user)
    cyber = Promotion.create!(name: 'Cyber Monday', description: 'Promoção de Cyber Monday',
                              code: 'CYBER15', discount_rate: 15, coupon_quantity: 90,
                              expiration_date: '22/12/2033', user: user)
    christmassy = Promotion.create!(name: 'Natalina', description: 'Promoção de natal',
                                    code: 'NATAL11', discount_rate: 10, coupon_quantity: 100,
                                    expiration_date: '22/12/2033', user: user)

    result = Promotion.search('natal')

    assert_includes result, christmassy
    assert_includes result, xmas
    assert_not_includes result, cyber
  end

  test 'search finds nothing' do
    user = User.create!(email: 'test@iugu.com.br', password: '123123', name: 'Fulano')
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user)
    Promotion.create!(name: 'Cyber Monday', description: 'Promoção de Cyber Monday',
                      code: 'CYBER15', discount_rate: 15, coupon_quantity: 90,
                      expiration_date: '22/12/2033', user: user)
    Promotion.create!(name: 'Natalina', description: 'Promoção de natal',
                      code: 'NATAL11', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user)

    result = Promotion.search('halloween')

    assert_empty result
  end
end
