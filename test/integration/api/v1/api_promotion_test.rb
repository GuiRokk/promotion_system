require 'test_helper'

class ApiPromotionTest < ActionDispatch::IntegrationTest
  test 'show promotion' do
    user = Fabricate(:user)
    promotion = Fabricate(:promotion, user: user)

    get "/api/v1/promotions/#{promotion.name}", as: :json

    assert_response :ok
    body = JSON.parse(response.body, symbolize_names: true)
    assert_equal promotion.name, body[:name]
    assert_equal promotion.description, body[:description]
    assert_equal promotion.code, body[:code]
    assert_equal number_to_percentage(promotion.discount_rate, separator: ',', precision: 2), body[:discount_rate]
    assert_equal promotion.coupon_quantity, body[:coupon_quantity]
    assert_equal '22/12/2033', body[:expiration_date]
    assert_equal promotion.user_id, body[:creator]
  end

  test 'cannot view promotion' do
    get '/api/v1/promotions/NATAL', as: :json

    assert_response :not_found
  end

  test 'index promotion' do
    promotion = Fabricate.times(2, :promotion)

    get '/api/v1/promotions', as: :json

    assert_response :ok
    body = JSON.parse(response.body, symbolize_names: true)
    assert_equal promotion[0].name, body[0][:name]
    assert_equal promotion[1].name, body[1][:name]
  end

  test 'no promotions to view in index' do
    get '/api/v1/promotions', as: :json

    assert_response :not_found
  end

  test 'create a promotion' do
    post '/api/v1/promotions', params: {
      promotion: Fabricate.attributes_for(:promotion, name: 'Natal', code: 'NATAL10')
    }, as: :json

    assert_response :created

    body = JSON.parse(response.body, symbolize_names: true)
    assert_equal 'Natal', body[:name]
    assert_equal 'Promoção de natal', body[:description]
    assert_equal 'NATAL10', body[:code]
    assert_equal '10,00%', body[:discount_rate]
    assert_equal 5, body[:coupon_quantity]
    assert_equal '22/12/2033', body[:expiration_date]
  end

  test 'cannot create a promotion with error => missing user' do
    post '/api/v1/promotions', params: { promotion: { name: 'Natal', description: 'Promoção de Natal',
                                                      code: 'NATAL10', discount_rate: 15, coupon_quantity: 5,
                                                      expiration_date: '22/12/2033' } }, as: :json

    assert_response :unprocessable_entity
  end

  test 'cannot create a promotion with missing argument => no name' do
    user = Fabricate(:user)

    post '/api/v1/promotions', params: { promotion: { description: 'Promoção de Natal',
                                                      code: 'NATAL10', discount_rate: 15, coupon_quantity: 5,
                                                      expiration_date: '22/12/2033', user_id: user.id } }, as: :json

    assert_response :unprocessable_entity
  end

  test 'cannot create a promotion with blanks' do
    post '/api/v1/promotions', params: { promotion: { name: '', description: '',
                                                      code: '', discount_rate: '', coupon_quantity: '',
                                                      expiration_date: '', user_id: '' } }, as: :json
    assert_not Promotion.last
    assert_response :unprocessable_entity
  end

  test 'destroy promotion' do
    promotion = Fabricate(:promotion)

    delete "/api/v1/promotions/#{promotion.name}", as: :json

    assert_response :no_content
    assert response.body, with: "Promoção #{promotion.name} apagada com sucesso"
    assert_not Promotion.last
  end

  test 'cannot destroy promotion with active coupons' do
    promotion = Fabricate(:promotion)
    Fabricate(:coupon, promotion: promotion)

    delete "/api/v1/promotions/#{promotion.name}", as: :json

    assert_response :unprocessable_entity
    assert Promotion.last
  end

  test 'update a promotion' do
    promotion = Fabricate(:promotion)

    patch "/api/v1/promotions/#{promotion.name}", params: {
      promotion: Fabricate.attributes_for(:promotion, name: 'Carnaval', description: 'Promoção de carnaval',
                                                      code: 'CARNA10', discount_rate: 20, coupon_quantity: 7,
                                                      expiration_date: '04/06/2055')
    }, as: :json

    assert_response :ok
    body = JSON.parse(response.body, symbolize_names: true)
    assert_equal 'Carnaval', body[:name]
    assert_equal 'Promoção de carnaval', body[:description]
    assert_equal 'CARNA10', body[:code]
    assert_equal '20,00%', body[:discount_rate]
    assert_equal 7, body[:coupon_quantity]
    assert_equal '04/06/2055', body[:expiration_date]
  end

  test 'cannot update a promotion, missing param => name' do
    promotion = Fabricate(:promotion)

    patch "/api/v1/promotions/#{promotion.name}", params: { promotion: { description: 'Promoção de Carnaval',
                                                                         code: 'CARNA20', discount_rate: 20,
                                                                         coupon_quantity: 7,
                                                                         expiration_date: '04/06/2055' } }, as: :json
    assert_response :unprocessable_entity
  end

  test 'route invalid without json header' do
    assert_raises ActionController::RoutingError do
      get '/api/v1/promotion/0'
    end
  end

  test 'cannot create promotion, name and code must be unique' do
    Fabricate(:promotion, name: 'Natal', code: 'NATAL10')

    post '/api/v1/promotions', params: { promotion: Fabricate.attributes_for(:promotion, name: 'Natal',
                                                                                         code: 'NATAL10') }, as: :json
    assert_response :unprocessable_entity
  end

  test 'cannot update a promotion, name and code must be unique' do
    Fabricate(:promotion, name: 'Natal', code: 'NATAL10')
    promotion = Fabricate(:promotion)

    patch "/api/v1/promotions/#{promotion.name}", params: { promotion: { name: 'Natal', code: 'NATAL10' } }, as: :json

    assert_response :unprocessable_entity
  end
end
