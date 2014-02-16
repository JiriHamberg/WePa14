require 'spec_helper'

include OwnTestHelper

describe "Beer" do
  let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }

  before :each do
    @user = FactoryGirl.create :user
    @style = FactoryGirl.create :style
  end

  it "when created, is registered to given brewery when name is valid" do
    sign_in(username:"Pekka", password:"Foobar1")
    visit new_beer_path
    select('Koff', from: 'beer[brewery_id]')
    select('Lager', from: 'beer[style_id]')
    fill_in('beer[name]', with: 'Mallas V')
    expect {
      click_button 'Create Beer'     
    }.to change{Beer.count}.from(0).to(1)
    visit beers_path
    expect(page).to have_content 'Mallas V'
  end

  it "when created, is rejected if name not valid" do
    sign_in(username:"Pekka", password:"Foobar1")
    visit new_beer_path
    select('Koff', from: 'beer[brewery_id]')
    fill_in('beer[name]', with: '')
    expect {
      click_button 'Create Beer'     
    }.not_to change{Beer.count}.from(0).to(1)
    expect(current_path).to eq(beers_path) #ei redirectata, vaan renderöidään new-template; siis ollaan sivulla /beers eikä /beers/new
    expect(page).to have_content "Name can't be blank"
  end
end