require 'rails_helper'

RSpec.feature "Role", :type => :feature do
  let!(:role) {FactoryBot.create(:role)}
  let!(:plan) {Plan.find(role.plan_id)}
  let!(:user) {User.find(plan.user_id)}

  let!(:user_2) {User.create!(email: 'user2@user2.com', password: 'skdD.sk@#ffe2w2', name: 'user2')}
  let!(:plan_2) {Plan.create!(name:"User 2 Plan", user_id: user_2.id)}
  let!(:role_2) {Role.create!(name: "Irmão", description: "Ser um irmão melhor", plan_id: plan_2.id)}
  let!(:role_3) {Role.create!(name: "Irmão 2", description: "Ser um irmão melhor", plan_id: plan_2.id)}

  before :each do
    login_as(user_2, scope: :user)
    user_2.selected_plan = plan_2.id
    user_2.save
  end

  context 'integration Privilege Escalation validations' do
    it 'default user can access all of his roles' do
      visit 'roles/'
      expect(page).to have_css('#card_of_paper', count: 2)
    end

    it 'default user cannot edit another user-s role' do
      visit 'roles/'+ (role.id).to_s + '/edit'
      expect(page).to have_content('You are not authorized to access this page.')
    end

    it 'default user can edit his own role' do
      visit 'roles/'+ (role_3.id).to_s + '/edit'
      expect(page).to have_content 'Edição de papel'
    end
  end

  context 'Crud integration' do
    it 'user can create role' do
      visit 'roles/new'
      fill_in 'role_name', with: 'role222'
      fill_in 'role_description', with: 'desc'
      click_button 'button-create-role'
      expect(page).to have_content('Papel foi criado com sucesso')
    end

    it 'user can edit role' do
      visit '/roles/' + (role_2.id).to_s + '/edit'
      fill_in 'role_name', with: 'role222'
      fill_in 'role_description', with: 'desc'
      click_button 'button-create-role'
      expect(page).to have_content('Papel foi atualizado com sucesso')
    end

    it 'user can view his role on myplan' do
      visit 'roles/new'
      fill_in 'role_name', with: 'role222'
      fill_in 'role_description', with: 'desc'
      click_button 'button-create-role'
      visit '/myplan'
      expect(page).to have_content('role222')
    end

    it 'user can delete his role' do
      visit 'roles/new'
      fill_in 'role_name', with: 'role222'
      fill_in 'role_description', with: 'desc'
      click_button 'button-create-role'
      visit '/roles/' + (role_2  .id).to_s + '/edit'
      click_link 'delete-role'
      expect(page).to have_content('Papel foi excluído')
    end
  end
end

