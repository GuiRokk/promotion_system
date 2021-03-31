require 'application_system_test_case'
include LoginMacros

class PromotionsTest < ApplicationSystemTestCase

  #todos os testes testando com o login efetuado

  test 'view promotions' do
    user = login_user
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user)
    Promotion.create!(name: 'Cyber Monday', description: 'Promoção de Cyber Monday',
                      code: 'CYBER15',discount_rate: 15,coupon_quantity: 90,
                      expiration_date: '22/12/2033', user: user)

    visit root_path
    click_on 'Promoções'
    assert_text 'Aguardando aprovação'
    refute_text 'Promoções aprovadas'
    assert_text 'Natal'
    assert_text 'Cyber Monday'
    refute_text 'Carnaval'
  end

  test 'view approved promotions' do
    user = User.create!(email: 'test@iugu.com.br', password: '123123', name: 'Fulano')
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user)
    Promotion.create!(name: 'Cyber Monday', description: 'Promoção de Cyber Monday',
                      code: 'CYBER15',discount_rate: 15,coupon_quantity: 90,
                      expiration_date: '22/12/2033', user: user)
    approver = login_user
    PromotionApproval.create!(promotion: promotion, user: approver)

    visit root_path
    click_on 'Promoções'
    assert_text 'Aguardando aprovação'
    assert_text 'Promoções aprovadas'
    assert_text 'Natal'
    assert_text 'Cyber Monday'
    refute_text 'Carnaval'
  end

  test 'view promotion details' do
    user = login_user
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user)
    Promotion.create!(name: 'Cyber Monday', description: 'Promoção de Cyber Monday',
                      code: 'CYBER15',discount_rate: 15,coupon_quantity: 90,
                      expiration_date: '22/12/2033', user: user)

    visit root_path
    click_on 'Promoções'
    click_on 'Cyber Monday'

    assert_text 'Cyber Monday'
    assert_text 'Promoção de Cyber Monday'
    assert_text '15,00%'
    assert_text 'CYBER15'
    assert_text '22/12/2033'
    assert_text '90'
  end

  test 'no promotion are available' do
    login_user
    visit root_path
    click_on 'Promoções'

    assert_text 'Nenhuma promoção cadastrada'
  end

  test 'view promotions and return to home page' do
    user = login_user
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user)

    visit root_path
    click_on 'Promoções'
    click_on 'Voltar'

    assert_current_path root_path
  end

  test 'view details and return to promotions page ' do
    user = login_user
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user)

    visit root_path
    click_on 'Promoções'
    click_on 'Natal'
    click_on 'Voltar'

    assert_current_path promotions_path
  end

  test 'create promotion ' do
    login_user
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
                      expiration_date: '22/12/2033',user: user)

    visit root_path
    click_on 'Promoções'
    click_on 'Registrar Promoção'
    fill_in 'Nome', with: 'Natal'
    fill_in 'Código', with: 'NATAL10'
    click_on 'Criar Promoção'

    assert_text 'já está em uso', count: 2
  end

  test 'generate coupons for a promotion' do
    user = User.create!(email: 'test@iugu.com.br', password: '123123', name: 'Fulano')
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)
    approver = login_user
    PromotionApproval.create!(promotion: promotion, user: approver)

    visit promotion_path(promotion)
    click_on 'Gerar cupons'

    assert_text 'Cupons gerados com sucesso'
    assert_no_link 'Gerar cupons'
    assert_no_text 'NATAL10-0000'
    assert_text    'NATAL10-0001'
    assert_text    'NATAL10-0100'
    assert_no_text 'NATAL10-0101'
    assert_no_link 'Editar Promoção'
  end

  test 'user edits a promotion' do
    user = login_user
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033',user: user)

    visit promotion_path(promotion)
    click_on "Editar Promoção"
    fill_in 'Nome', with: 'Halloween'
    click_on 'Atualizar Promoção'

    assert_text 'Promoção editada com sucesso'
    assert_text 'Halloween'
    assert_no_link 'Natal'
  end

  test 'user edits a promotion with blanks' do
    user = login_user
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)

    visit promotion_path(promotion)
    click_on "Editar Promoção"
    fill_in 'Nome', with: ''
    fill_in 'Descrição', with: ''
    fill_in 'Código', with: ''
    fill_in 'Desconto', with: ''
    fill_in 'Quantidade de cupons', with: ''
    fill_in 'Data de término', with: ''
    click_on 'Atualizar Promoção'

    assert_text 'não pode ficar em branco', count: 5
  end

  test 'user edits a promotion with repeated name/code' do
    user = login_user
    Promotion.create!(name: 'Cyber Monday', description: 'Promoção de Cyber Monday',
                      code: 'CYBER15',discount_rate: 15,coupon_quantity: 90,
                      expiration_date: '22/12/2033', user: user)

    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)

    visit promotion_path(promotion)
    click_on "Editar Promoção"
    fill_in 'Nome', with: 'Cyber Monday'
    fill_in 'Código', with: 'CYBER15'

    click_on 'Atualizar Promoção'
    assert_text 'já está em uso', count: 2
  end

  test 'delete a promotion' do
    user = login_user
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)

    visit promotion_path(promotion)
    click_on 'Apagar Promoção'

    assert_current_path promotions_path
    assert_text "Promoção #{promotion.name} apagada com sucesso"
    assert_text "Nenhuma promoção cadastrada"
    assert_no_link 'Natal'
  end

  test 'delete with a remaining promotion ' do
    user = login_user
    Promotion.create!(name: 'Cyber Monday', description: 'Promoção de Cyber Monday',
                      code: 'CYBER15',discount_rate: 15,coupon_quantity: 90,
                      expiration_date: '22/12/2033', user: user)

    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)

    visit promotion_path(promotion)
    click_on 'Apagar Promoção'

    assert_current_path promotions_path
    assert_text "Promoção #{promotion.name} apagada com sucesso"
    assert_no_link 'Natal'
    assert_link 'Cyber Monday'
  end

  test 'cannot delete promotion with active coupons ' do
    user = User.create!(email: 'test@iugu.com.br', password: '123123', name: 'Fulano')
    promotion = Promotion.create!(name: 'Cyber Monday', description: 'Promoção de Cyber Monday',
                      code: 'CYBER15',discount_rate: 15,coupon_quantity: 90,
                      expiration_date: '22/12/2033', user: user)
    approver = login_user
    PromotionApproval.create!(promotion: promotion, user: approver)

    visit promotion_path(promotion)
    click_on 'Gerar cupons'

    assert_current_path promotion_path(promotion)
    assert_no_link 'Apagar'
    assert_text 'Ativo', count: promotion.coupon_quantity
  end

  test 'delete promotion with no active coupons ' do
    user = User.create!(email: 'test@iugu.com.br', password: '123123', name: 'Fulano')
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 2,
                                  expiration_date: '22/12/2033', user: user)
    approver = login_user
    PromotionApproval.create!(promotion: promotion, user: approver)

    visit promotion_path(promotion)
    click_on 'Gerar cupons'
    within 'td#action-natal10-0001' do
      click_on "Desativar"
    end
    within 'td#action-natal10-0002' do
      click_on "Desativar"
    end
    click_on 'Apagar Promoção'

    assert_current_path promotions_path
    assert_text "Promoção #{promotion.name} apagada com sucesso"
    assert_no_link 'Natal'
    refute Coupon.exists?(promotion_id: promotion.id)
  end

  test "don't view promotion link without login" do

    visit root_path

    assert_no_link 'Promoções'
  end

  test "don't view promotions using route without login" do

    visit promotions_path

    assert_current_path new_user_session_path
  end

  test "don't view promotions details using route without login" do
    user = User.create!(email: 'test@iugu.com.br', password: '123123', name: 'Fulano')
    promotion = Promotion.create!(name: 'Cyber Monday', description: 'Promoção de Cyber Monday',
                      code: 'CYBER15',discount_rate: 15,coupon_quantity: 90,
                      expiration_date: '22/12/2033', user: user)

    visit promotion_path(promotion)

    assert_current_path new_user_session_path
end

  test 'user reactivates coupon' do
    user = User.create!(email: 'test@iugu.com.br', password: '123123', name: 'Fulano')
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 2,
                                  expiration_date: '22/12/2033', user: user)
    approver = login_user
    PromotionApproval.create!(promotion: promotion, user: approver)

    visit promotion_path(promotion)
    click_on 'Gerar cupons'
    within 'td#action-natal10-0001' do
      click_on "Desativar"
    end
    within 'td#action-natal10-0002' do
      click_on "Desativar"
    end
    within 'td#action-natal10-0001' do
      click_on "Reativar"
    end

    within 'td#action-natal10-0001' do
      assert_link 'Desativar'
      assert_no_link 'Reativar'
  end
    assert_text 'Ativo', count:1
    assert_text 'Desativado',count:1
  end

  test 'search promotion by term and finds results' do
    user = login_user
    xmas = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user)
    cyber = Promotion.create!(name: 'Cyber Monday', description: 'Promoção de Cyber Monday',
                      code: 'CYBER15',discount_rate: 15,coupon_quantity: 90,
                      expiration_date: '22/12/2033', user: user)
    christmassy = Promotion.create!(name: 'Natalina', description: 'Promoção de natal',
                      code: 'NATAL11', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user)

    visit root_path
    click_on 'Promoções'
    within 'form' do
      fill_in 'query', with: 'natal'
      click_on 'Buscar'
    end

    assert_text xmas.name
    assert_text christmassy.name
    assert_no_text cyber.name
  end

  test 'user approves promotion' do
    user = User.create!(email: 'test@iugu.com.br', password: '123123', name: 'Fulano')
    promotion = Promotion.create!(name: 'Cyber Monday', description: 'Promoção de Cyber Monday',
                      code: 'CYBER15',discount_rate: 15,coupon_quantity: 90,
                      expiration_date: '22/12/2033', user: user)

    approver = login_user
    visit promotion_path(promotion)
    accept_confirm {click_on 'Aprovar'}

    assert_text 'Promoção aprovada com sucesso'
    assert_text "Aprovada por: #{approver.email}"
    assert_link 'Gerar cupons'
    refute_link "Aprovar"
  end


  test 'can delete only an approved promotion' do
    user = login_user
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)

    visit promotion_path(promotion)
    accept_confirm {click_on 'Aprovar'}
    click_on 'Apagar Promoção'

    assert_current_path promotions_path
    assert_text "Promoção #{promotion.name} apagada com sucesso"
    assert_text "Nenhuma promoção cadastrada"
    assert_no_link 'Natal'
  end





   #TODO: NAO ENCONTRA NADA
   #TODO: VISIT PAGINA SEM ESTAR LOGADO
   #TODO: SEARCH_PROMOTIONS (q: 'natal')
   #TODO: ORGANIZAR ESSES TESTES
   #TODO: SÓ PODE EDITAR QUEM CRIOU A PROMOÇÃO ?
   #TODO: TESTAR NO INDEX PROMOÇÕES APRODAS DE AGUARDANDO APROVAÇÃO
end