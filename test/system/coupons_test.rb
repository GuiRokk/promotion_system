require "application_system_test_case"

class CouponsTest < ApplicationSystemTestCase

  test 'disable a coupon' do
    
    promotion = Promotion.create!(name: 'Natal',
                                  description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, 
                                  coupon_quantity: 1,
                                  expiration_date: '22/12/2033')
    coupon = Coupon.create!(code: 'NATAL10-0001', promotion: promotion)

    login_user()
    visit promotion_path(promotion)
    within 'div#coupon-natal10-0001' do
      click_on 'Desativar'
    end

    assert_text "Cupom NATAL10-0001 desativado com sucesso"
    assert_text "#{coupon.code} (desativado)"
    within 'div#coupon-natal10-0001' do
      assert_no_link "Desativar"
    end
    assert_link 'Desativar', count: promotion.coupon_quantity - 1
  end


  test 'coupon is created, exists' do
    promotion = Promotion.create!(name: 'Natal',
                                  description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, 
                                  coupon_quantity: 10,
                                  expiration_date: '22/12/2033')

    login_user()
    visit promotion_path(promotion)
    click_on 'Gerar cupons'
    assert Coupon.any?
    assert Coupon.count == promotion.coupon_quantity
  end
end