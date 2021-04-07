require 'application_system_test_case'

class CreatePromotionsTest < ApplicationSystemTestCase
  include LoginMacros

  test 'create promotion ' do
    user = login_user
    visit root_path
    click_on 'Promoções'
    click_on 'Registrar Promoção'
    fill_in 'Nome', with: 'Cyber Monday'
    fill_in 'Descrição', with: 'Promoção de Cyber Monday'
    fill_in 'Código', with: 'CYBER15'
    fill_in 'Desconto', with: '15'
    fill_in 'Quantidade de cupons', with: '90'
    fill_in 'Data de término', with: '12/22/2033'
    click_on 'Criar Promoção'

    assert_current_path promotion_path(Promotion.last)
    assert_text 'Cyber Monday'
    assert_text 'Promoção de Cyber Monday'
    assert_text '15,00%'
    assert_text 'CYBER15'
    assert_text '22/12/2033'
    assert_text '90'
    assert_link 'Voltar'
    assert_link 'Aprovar'
    assert_text "Criado por: #{user.email}"
    refute_text 'Aprovado por:'
  end

  test 'create attributes cannot be blank ' do
    login_user
    visit root_path
    click_on 'Promoções'
    click_on 'Registrar Promoção'
    click_on 'Criar Promoção'

    assert_text 'não pode ficar em branco', count: 5
  end

  test 'create name/code must be unique ' do
    user = login_user
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user)

    visit root_path
    click_on 'Promoções'
    click_on 'Registrar Promoção'
    fill_in 'Nome', with: 'Natal'
    fill_in 'Código', with: 'NATAL10'
    click_on 'Criar Promoção'

    assert_text 'já está em uso', count: 2
  end

  test 'create date cannot be in the past ' do
    login_user
    visit root_path
    click_on 'Promoções'
    click_on 'Registrar Promoção'
    fill_in 'Data de término', with: '12/22/1988'
    click_on 'Criar Promoção'

    assert_text 'não pode ser no passado'
  end

  test 'generate coupons for a promotion' do
    user = login_user
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)
    approver = login_approver
    PromotionApproval.create!(promotion: promotion, user: approver)

    visit promotion_path(promotion)
    click_on 'Gerar cupons'

    assert_text 'Cupons gerados com sucesso'
    refute_link 'Gerar cupons'
    refute_text 'NATAL10-0000'
    assert_text 'NATAL10-0001'
    assert_text 'NATAL10-0100'
    refute_text 'NATAL10-0101'
    refute_link 'Editar Promoção'
  end
end
