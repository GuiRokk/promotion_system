require 'application_system_test_case'
include LoginMacros

class ApprovePromotionsTest < ApplicationSystemTestCase
  test 'user approves promotion' do
    user = login_user
    promotion = Promotion.create!(name: 'Cyber Monday', description: 'Promoção de Cyber Monday',
                      code: 'CYBER15',discount_rate: 15,coupon_quantity: 90,
                      expiration_date: '22/12/2033', user: user)

    approver = login_approver
    visit promotion_path(promotion)
    accept_confirm {click_on 'Aprovar'}

    assert_text 'Promoção aprovada com sucesso'
    assert_text "Criado por: #{user.email}"
    assert_text "Aprovado por: #{approver.email}"
    assert_link 'Gerar cupons'
    refute_link "Aprovar"
  end

  test 'promotion creator cannot approve promotion' do
    user = login_user
    promotion = Promotion.create!(name: 'Cyber Monday', description: 'Promoção de Cyber Monday',
                      code: 'CYBER15',discount_rate: 15,coupon_quantity: 90,
                      expiration_date: '22/12/2033', user: user)

    visit promotion_path(promotion)
    accept_confirm {click_on 'Aprovar'}
    assert_text 'Não pode ser aprovado pelo criador da promoção'
    refute_text 'Promoção aprovada com sucesso'
    refute_text "Aprovado por: #{user.email}"
    refute_link 'Gerar cupons'
  end
end