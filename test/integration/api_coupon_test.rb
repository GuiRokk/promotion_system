require 'test_helper'

class ApiCouponTest < ActionDispatch::IntegrationTest
  test 'show coupon' do
    user = User.create!(email: 'test@iugu.com.br', password: '123123', name: 'Fulano')
    promotion = Promotion.create!(name: 'Natal',
                                  description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10,
                                  coupon_quantity: 2,
                                  expiration_date: '22/12/2033', user: user)
    coupon = Coupon.create!(code: 'NATAL10-0001', promotion: promotion, status: 0)

    get "/api/v1/coupons/#{coupon.code}", as: :json

    assert_response :ok

    body = JSON.parse(response.body, symbolize_names: true)
    assert_equal coupon.code, body[:code]
    assert_equal number_to_percentage(promotion.discount_rate, precision: 2, separator: ','), body[:discount_rate]
    assert_equal '22/12/2033', body[:expiration_date]
    assert_equal coupon.status, body[:status]
  end

  test 'cannot show disabled coupon' do
    user = User.create!(email: 'test@iugu.com.br', password: '123123', name: 'Fulano')
    promotion = Promotion.create!(name: 'Natal',
                                  description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10,
                                  coupon_quantity: 2,
                                  expiration_date: '22/12/2033', user: user)
    coupon = Coupon.create!(code: 'NATAL10-0001', promotion: promotion, status: 10)

    get "/api/v1/coupons/#{coupon.code}", as: :json

    assert_response :not_found
  end

  test 'show coupon not found' do
    get '/api/v1/coupons/qwerty', as: :json

    assert_response :not_found
  end

  test 'burn a coupon' do
    user = User.create!(email: 'test@iugu.com.br', password: '123123', name: 'Fulano')
    promotion = Promotion.create!(name: 'Natal',
                                  description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10,
                                  coupon_quantity: 2,
                                  expiration_date: '22/12/2033', user: user)
    coupon = Coupon.create!(code: 'NATAL10-0001', promotion: promotion, status: 0)

    post "/api/v1/coupons/#{coupon.code}/burn", as: :json

    assert_response :ok
    body = JSON.parse(response.body, symbolize_names: true)
    assert_equal 'burned', body[:status]
  end

  test 'show coupon category' do
    user = User.create!(email: 'test@iugu.com.br', password: '123123', name: 'Fulano')
    promotion = Promotion.create!(name: 'Natal',
                                  description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10,
                                  coupon_quantity: 2,
                                  expiration_date: '22/12/2033', user: user)
    coupon = Coupon.create!(code: 'NATAL10-0001', promotion: promotion, status: 0)

    get "/api/v1/coupons/#{coupon.code}", as: :json

    assert_response :ok

    body = JSON.parse(response.body, symbolize_names: true)
    assert_equal coupon.code, body[:code]
    assert_equal number_to_percentage(promotion.discount_rate, precision: 2, separator: ','), body[:discount_rate]
    assert_equal '22/12/2033', body[:expiration_date]
    assert_equal coupon.status, body[:status]
  end
end
