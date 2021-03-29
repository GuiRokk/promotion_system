require "application_system_test_case"
include LoginMacros

class CouponsTest < ApplicationSystemTestCase

  test 'coupon is created, exists' do
    promotion = Promotion.create!(name: 'Natal',
                                  description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, 
                                  coupon_quantity: 10,
                                  expiration_date: '22/12/2033')

    login_user
    visit promotion_path(promotion)
    click_on 'Gerar cupons'
    assert Coupon.any?
    assert Coupon.count == promotion.coupon_quantity
  end

  test 'disable a coupon' do
    promotion = Promotion.create!(name: 'Natal',
                                  description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, 
                                  coupon_quantity: 1,
                                  expiration_date: '22/12/2033')
    coupon = Coupon.create!(code: 'NATAL10-0001', promotion: promotion)

    login_user
    visit promotion_path(promotion)
    within 'div#coupon-natal10-0001' do
      click_on 'Desativar'
    end

    assert_text "Cupom NATAL10-0001 desativado com sucesso"
    assert_text "#{coupon.code} (Desativado)"
    within 'div#coupon-natal10-0001' do
      assert_no_link "Desativar"
    end
    assert_link 'Desativar', count: promotion.coupon_quantity - 1
  end

  test 're-enables a coupon' do
    promotion = Promotion.create!(name: 'Natal',
                                  description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, 
                                  coupon_quantity: 1,
                                  expiration_date: '22/12/2033')
    coupon = Coupon.create!(code: 'NATAL10-0001', promotion: promotion)

    login_user
    visit promotion_path(promotion)
    within 'div#coupon-natal10-0001' do
      click_on 'Desativar'
    end
    within 'div#coupon-natal10-0001' do
      click_on 'Reativar'
    end

    assert_text "Cupom NATAL10-0001 reativado com sucesso"
    assert_text "#{coupon.code} (Ativo)"
    within 'div#coupon-natal10-0001' do
      assert_link "Desativar"
      assert_no_link 'Reativar'
    end
    assert_link 'Reativar', count: promotion.coupon_quantity - 1
  end

  test 'search coupon successfuly' do
    promotion = Promotion.create!(name: 'Natal',
                                  description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, 
                                  coupon_quantity: 1,
                                  expiration_date: '22/12/2033')
    coupon = Coupon.create!(code: 'NATAL10-0001', promotion: promotion)

    login_user
    visit promotions_path
    within 'form' do
      fill_in 'query', with: coupon.code
      click_on 'Buscar por cupom'
    end

    assert_text 'Código'
    assert_text coupon.code
    assert_text 'Nome Promoção'
    assert_text coupon.promotion.name
    assert_text 'Status'
    assert_text 'Ativo'
    assert_no_text 'Cupom não encontrado'
    assert_link 'Voltar'
    assert_link 'Ir para Promoção'
  end

  test 'search invalid coupon code' do
    promotion = Promotion.create!(name: 'Natal',
                                  description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, 
                                  coupon_quantity: 1,
                                  expiration_date: '22/12/2033')
    coupon = Coupon.create!(code: 'NATAL10-0001', promotion: promotion)

    login_user
    visit promotions_path
    within 'form' do
      fill_in 'query', with: 'NATAL10 0001'
      click_on 'Buscar por cupom'
    end

    assert_no_current_path search_path
    assert_text 'Cupom não encontrado'
    assert_current_path promotions_path
  end


end