require "application_system_test_case"
include LoginMacros

class CouponsTest < ApplicationSystemTestCase

  #testes rodando com login efetuado e promoções aprovadas

  test 'coupon is created, exists' do
    user = User.create!(email: 'test@iugu.com.br', password: '123123', name: 'Fulano')
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user:user)
    approver = login_user
    PromotionApproval.create!(promotion: promotion, user: approver)

    visit promotion_path(promotion)
    click_on 'Gerar cupons'
    assert Coupon.any?
    assert Coupon.count == promotion.coupon_quantity
  end

  test 'disable a coupon' do
    user = User.create!(email: 'test@iugu.com.br', password: '123123', name: 'Fulano')
    promotion = Promotion.create!(name: 'Natal',
                                  description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, 
                                  coupon_quantity: 1,
                                  expiration_date: '22/12/2033', user: user)
    approver = login_user
    PromotionApproval.create!(promotion: promotion, user: approver)
    coupon = Coupon.create!(code: 'NATAL10-0001', promotion: promotion)

    visit promotion_path(promotion)
    within 'td#action-natal10-0001' do
      click_on 'Desativar'
    end

    assert_text "Cupom NATAL10-0001 desativado com sucesso"
    within 'td#action-natal10-0001' do
      assert_no_link "Desativar"
      assert_link 'Reativar'
    end
    assert_text 'Cupom NATAL10-0001 desativado com sucesso'
  end

  test 're-enables a coupon' do
    user = User.create!(email: 'test@iugu.com.br', password: '123123', name: 'Fulano')
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user:user)
    approver = login_user
    PromotionApproval.create!(promotion: promotion, user: approver)
    coupon = Coupon.create!(code: 'NATAL10-0001', promotion: promotion)

    visit promotion_path(promotion)
    within 'td#action-natal10-0001' do
      click_on 'Desativar'
      click_on 'Reativar'
    end

    within 'td#action-natal10-0001' do
      assert_no_link "Reativar"
      assert_link 'Desativar'
    end
    assert_text "Cupom NATAL10-0001 reativado com sucesso"
  end

  test 'search coupon successfuly' do
    user =  login_user
    promotion = Promotion.create!(name: 'Natal',
                                  description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, 
                                  coupon_quantity: 1,
                                  expiration_date: '22/12/2033', user: user)
    coupon = Coupon.create!(code: 'NATAL10-0001', promotion: promotion)

    visit promotions_path
    within 'form' do
      fill_in 'query', with: coupon.code
      click_on 'Buscar'
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
    user = login_user
    promotion = Promotion.create!(name: 'Natal',
                                  description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, 
                                  coupon_quantity: 1,
                                  expiration_date: '22/12/2033', user: user)
    coupon = Coupon.create!(code: 'NATAL10-0001', promotion: promotion)

    visit promotions_path
    within 'form' do
      fill_in 'query', with: 'NATAL10 0001'
      click_on 'Buscar'
    end

    assert_text 'Item buscado não encontrado'
    assert_current_path promotions_path
  end
end