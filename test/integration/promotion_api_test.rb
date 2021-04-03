require 'test_helper'

class PromotionApiTest < ActionDispatch::IntegrationTest
  test 'show coupon' do
    user = User.create!(email: 'test@iugu.com.br', password: '123123', name: 'Fulano')
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 15,
                      expiration_date: '22/12/2033', user: user)
    coupon = Coupon.create!(code: 'NATAL10-0001', promotion: promotion)

    get "/api/v1/coupons/#{coupon.code}", as: :json

    assert_response :success
    body =  JSON.parse(response.body, symbolize_names: true)
    assert_equal coupon.code, body[:code]
  end
end

#TODO: BRINCAR COM O CRUD DA API, FIM DA AULArail