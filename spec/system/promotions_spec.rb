require 'rails_helper'

	describe 'Promotions test', do
		it 'view promotions', :js do
			user = user = User.create!(email: 'test@iugu.com.br', password: '123123', name: '')
			Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
												code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
												expiration_date: '22/12/2033', user: user)
			Promotion.create!(name: 'Cyber Monday', description: 'Promoção de Cyber Monday',
												code: 'CYBER15', discount_rate: 15, coupon_quantity: 90,
												expiration_date: '22/12/2033', user: user)
			login_as user, scope: :user
			visit root_path
			click_on 'Promoções'
			assert_text 'Aguardando aprovação'
			refute_text 'Promoções aprovadas'
			assert_text 'Natal'
			assert_text 'Cyber Monday'
			refute_text 'Carnaval'
		end
	end

	