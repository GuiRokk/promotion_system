require 'application_system_test_case'

class CouponsTest < ApplicationSystemTestCase
  include LoginMacros

  test 'coupon is created, exists' do
    user = login_user
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)
    approver = login_approver
    PromotionApproval.create!(promotion: promotion, user: approver)

    visit promotion_path(promotion)
    click_on 'Gerar cupons'
    assert Coupon.any?
    assert Coupon.count == promotion.coupon_quantity
  end

  test 'disable a coupon' do
    user = login_user
    promotion = Promotion.create!(name: 'Natal',
                                  description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10,
                                  coupon_quantity: 1,
                                  expiration_date: '22/12/2033', user: user)
    approver = login_approver
    PromotionApproval.create!(promotion: promotion, user: approver)
    Coupon.create!(code: 'NATAL10-0001', promotion: promotion)

    visit promotion_path(promotion)
    within 'td#action-natal10-0001' do
      click_on 'Desativar'
    end

    assert_text 'Cupom NATAL10-0001 desativado com sucesso'
    within 'td#action-natal10-0001' do
      refute_link 'Desativar'
      assert_link 'Reativar'
    end
    assert_text 'Cupom NATAL10-0001 desativado com sucesso'
  end

  test 're-enables a coupon' do
    user = login_user
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)
    approver = login_approver
    PromotionApproval.create!(promotion: promotion, user: approver)
    Coupon.create!(code: 'NATAL10-0001', promotion: promotion)

    visit promotion_path(promotion)
    within 'td#action-natal10-0001' do
      click_on 'Desativar'
      click_on 'Reativar'
    end

    within 'td#action-natal10-0001' do
      refute_link 'Reativar'
      assert_link 'Desativar'
    end
    assert_text 'Cupom NATAL10-0001 reativado com sucesso'
  end

  test 'search coupon successfuly' do
    user = login_user
    promotion = Promotion.create!(name: 'Natal',
                                  description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10,
                                  coupon_quantity: 1,
                                  expiration_date: '22/12/2033', user: user)
    coupon = Coupon.create!(code: 'NATAL10-0001', promotion: promotion)
    approver = login_approver
    PromotionApproval.create!(promotion: promotion, user: approver)

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
    refute_text 'Cupom não encontrado'
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
    Coupon.create!(code: 'NATAL10-0001', promotion: promotion)
    approver = login_approver
    PromotionApproval.create!(promotion: promotion, user: approver)

    visit promotions_path
    query = 'NATAL10 0001'
    within 'form' do
      fill_in 'query', with: query
      click_on 'Buscar'
    end

    assert_text 'Item buscado não encontrado'
    assert_current_path promotions_path(query: query)
  end

  test 'cannot created coupon without login' do
    user = User.create!(email: 'test@iugu.com.br', password: '123123', name: 'Fulano')
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)
    approver = User.create!(email: 'peter@iugu.com.br', password: '123123', name: 'Peter')
    PromotionApproval.create!(promotion: promotion, user: approver)

    visit promotion_path(promotion)
    refute_link 'Gerar cupons'
    assert_current_path new_user_session_path
  end
end
