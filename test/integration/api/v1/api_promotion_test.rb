require 'test_helper'

class ApiPromotionTest < ActionDispatch::IntegrationTest
  test 'show promotion' do
    user = User.create!(email: 'test@iugu.com.br', password: '123123', name: 'Fulano')
    promotion = Promotion.create!(name: 'Natal',
                                  description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10,
                                  coupon_quantity: 2,
                                  expiration_date: '22/12/2033', user: user)

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
    user = User.create!(email: 'test@iugu.com.br', password: '123123', name: 'Fulano')
    natal = Promotion.create!(name: 'Natal',
                              description: 'Promoção de Natal',
                              code: 'NATAL10', discount_rate: 10,
                              coupon_quantity: 2,
                              expiration_date: '22/12/2033', user: user)
    cyber = Promotion.create!(name: 'Cyber',
                              description: 'Promoção de Cyber',
                              code: 'CYBER10', discount_rate: 10,
                              coupon_quantity: 2,
                              expiration_date: '22/12/2033', user: user)

    get '/api/v1/promotions', as: :json

    assert_response :ok
    body = JSON.parse(response.body, symbolize_names: true)
    assert_equal natal.name, body[0][:name]
    assert_equal cyber.name, body[1][:name]
  end

  test 'no promotions to view in index' do
    get '/api/v1/promotions', as: :json

    assert_response :not_found
  end

  test 'create a promotion' do
    user = User.create!(email: 'test@iugu.com.br', password: '123123', name: '')
    post '/api/v1/promotions', params: { promotion: { name: 'Natal', description: 'Promoção de Natal',
                                                      code: 'NATAL10', discount_rate: 15, coupon_quantity: 5,
                                                      expiration_date: '22/12/2033', user_id: user.id } }, as: :json

    assert_response :created

    body = JSON.parse(response.body, symbolize_names: true)
    assert_equal 'Natal', body[:name]
    assert_equal 'Promoção de Natal', body[:description]
    assert_equal 'NATAL10', body[:code]
    assert_equal '15,00%', body[:discount_rate]
    assert_equal 5, body[:coupon_quantity]
    assert_equal '22/12/2033', body[:expiration_date]
  end

  test 'cannot create a promotion with error => missing user' do
    post '/api/v1/promotions', params: { promotion: { name: 'Natal', description: 'Promoção de Natal',
                                                      code: 'NATAL10', discount_rate: 15, coupon_quantity: 5,
                                                      expiration_date: '22/12/2033' } }, as: :json

    assert_response :unprocessable_entity
  end

  test 'cannot create a promotion with error => no name' do
    user = User.create!(email: 'test@iugu.com.br', password: '123123', name: '')
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
    user = User.create!(email: 'test@iugu.com.br', password: '123123', name: 'Fulano')
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal', code: 'NATAL10', discount_rate: 10,
                                  coupon_quantity: 2,	expiration_date: '22/12/2033', user: user)
    delete '/api/v1/promotions/Natal', as: :json

    assert_response :no_content
    assert response.body, with: "Promoção #{promotion.name} apagada com sucesso"
    assert_not Promotion.last
  end

  test 'cannot destroy promotion with active coupons' do
    user = User.create!(email: 'test@iugu.com.br', password: '123123', name: 'Fulano')
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal', code: 'NATAL10', discount_rate: 10,
                                  coupon_quantity: 2,	expiration_date: '22/12/2033', user: user)
    Coupon.create!(code: 'NATAL10-0001', promotion: promotion, status: 0)

    delete '/api/v1/promotions/Natal', as: :json

    assert_response :unprocessable_entity
    assert Promotion.last
  end

  test 'update a promotion' do
    user = User.create!(email: 'test@iugu.com.br', password: '123123', name: 'Fulano')
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal', code: 'NATAL10', discount_rate: 10,
                                  coupon_quantity: 2,	expiration_date: '22/12/2033', user: user)

    patch "/api/v1/promotions/#{promotion.name}", params: { promotion: { name: 'Carnaval',
                                                                         description: 'Promoção de Carnaval',
                                                                         code: 'CARNA20',
                                                                         discount_rate: 20, coupon_quantity: 7,
                                                                         expiration_date: '04/06/2055' } }, as: :json
    assert_response :ok
    body = JSON.parse(response.body, symbolize_names: true)
    assert_equal 'Carnaval', body[:name]
    assert_equal 'Promoção de Carnaval', body[:description]
    assert_equal 'CARNA20', body[:code]
    assert_equal '20,00%', body[:discount_rate]
    assert_equal 7, body[:coupon_quantity]
    assert_equal '04/06/2055', body[:expiration_date]
  end

  test 'cannot update a promotion, missing param => name' do
    user = User.create!(email: 'test@iugu.com.br', password: '123123', name: 'Fulano')
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal', code: 'NATAL10', discount_rate: 10,
                                  coupon_quantity: 2,	expiration_date: '22/12/2033', user: user)

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
    user = User.create!(email: 'test@iugu.com.br', password: '123123', name: 'Fulano')
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal', code: 'NATAL10', discount_rate: 10,
                      coupon_quantity: 2,	expiration_date: '22/12/2033', user: user)

    post '/api/v1/promotions', params: { promotion: { name: 'Natal', description: 'Promoção de Natal',
                                                      code: 'NATAL10', discount_rate: 15, coupon_quantity: 5,
                                                      expiration_date: '22/12/2033', user_id: user.id } }, as: :json

    assert_response :unprocessable_entity
  end

  test 'cannot update a promotion, name and code must be unique' do
    user = User.create!(email: 'test@iugu.com.br', password: '123123', name: 'Fulano')
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal', code: 'NATAL10', discount_rate: 10,
                      coupon_quantity: 2,	expiration_date: '22/12/2033', user: user)
    promotion = Promotion.create!(name: 'Cyber', description: 'Promoção de Cyber', code: 'CYBER15', discount_rate: 10,
                                  coupon_quantity: 2,	expiration_date: '22/12/2033', user: user)

    patch "/api/v1/promotions/#{promotion.name}", params: { promotion: { name: 'Natal',
                                                                         description: 'Promoção de Natal',
                                                                         code: 'NATAL10', discount_rate: 10,
                                                                         coupon_quantity: 2,
                                                                         expiration_date: '22/12/2033',
                                                                         user: user } }, as: :json

    assert_response :unprocessable_entity
  end
end
