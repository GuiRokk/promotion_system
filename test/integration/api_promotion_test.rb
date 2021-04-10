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

		get "/api/v1/promotions/NATAL"

		assert response.body, with: "Atenção - Promoção Inexistente"
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

	test 'any promotion to view in index promotion' do

		get '/api/v1/promotions'

		assert response.body, with: 'Nada para mostrar - Não existem promoções cadastradas'
	end

	test 'create a promotion' do
		user = login_user
    post '/api/v1/promotions', params: { promotion: { name: 'Natal', description: 'Promoção de Natal',
                                                 code: 'NATAL10', discount_rate: 15, coupon_quantity: 5,
                                                 expiration_date: '22/12/2033', user_id: user.id} }
	
		#TODO: TERMINAR AQUI
	end
end
