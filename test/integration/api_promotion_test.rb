require 'test_helper'

class ApiPromotionTest < ActionDispatch::IntegrationTest
  include LoginMacros

  test 'show promotion' do
    user = User.create!(email: 'test@iugu.com.br', password: '123123', name: 'Fulano')
    promotion = Promotion.create!(name: 'Natal',
                                  description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10,
                                  coupon_quantity: 2,
                                  expiration_date: '22/12/2033', user: user)

    get "/api/v1/promotions/#{promotion.name}"

    assert_equal promotion.name, response.parsed_body['name']
    assert_response :ok
  end

  test 'cannot view promotion' do
    get '/api/v1/promotions/NATAL'

    assert response.body, with: 'Atenção - Promoção Inexistente'
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

    get '/api/v1/promotions'

    assert_response :ok
    body = JSON.parse(response.body, symbolize_names: true)
    assert_equal natal.name, body[0][:name]
    assert_equal cyber.name, body[1][:name]
  end

  test 'no promotions to view in index promotion' do
    get '/api/v1/promotions'

    assert response.body, with: 'Nada para mostrar - Não existem promoções cadastradas'
  end

  test 'create a promotion' do
    user = User.create!(email: 'test@iugu.com.br', password: '123123', name: '')
    post '/api/v1/promotions', params: { promotion: { name: 'Natal', description: 'Promoção de Natal',
                                                      code: 'NATAL10', discount_rate: 15, coupon_quantity: 5,
                                                      expiration_date: '22/12/2033', user_id: user.id } }

    assert_response :ok
    body = JSON.parse(response.body, symbolize_names: true)
    assert_equal 'Natal', body[:name]
    assert_equal 'Promoção de Natal', body[:description]
    assert_equal 'NATAL10', body[:code]
    assert_equal '15.0', body[:discount_rate]
    assert_equal 5, body[:coupon_quantity]
    assert_equal '2033-12-22', body[:expiration_date]
  end

  test 'cannot create a promotion with error => no user' do
    post '/api/v1/promotions', params: { promotion: { name: 'Natal', description: 'Promoção de Natal',
                                                      code: 'NATAL10', discount_rate: 15, coupon_quantity: 5,
                                                      expiration_date: '22/12/2033' } }

    assert_response :ok
    body = JSON.parse(response.body, symbolize_names: true)
    assert_equal ['é obrigatório(a)'], body[:user]
  end

  test 'destroy promotion' do
    user = User.create!(email: 'test@iugu.com.br', password: '123123', name: 'Fulano')
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal', code: 'NATAL10', discount_rate: 10,
                                  coupon_quantity: 2,	expiration_date: '22/12/2033', user: user)
    delete '/api/v1/promotions/Natal'

    assert_response :ok
    assert response.body, with: "Promoção #{promotion.name} apagada com sucesso"
    assert_not Promotion.last
  end
end
