require 'spec_helper'

include OwnTestHelper

describe "User" do
  before :each do
    @user = FactoryGirl.create :user
  end

  describe "who has signed up" do
    it "can signin with right credentials" do
      sign_in(username:"Pekka", password:"Foobar1")

      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end

    it "is redirected back to signin form if wrong credentials given" do
      sign_in(username:"Pekka", password:"wrong")
      
      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'username and password do not match'
    end

    it "can see all his/her ratings on his/her page" do
      scores = [11, 13, 22, 14, 15, 16]
      beer = FactoryGirl.create :beer
      create_ratings *scores, @user, beer

      visit user_path(@user)
      scores.each do |score|
        expect(page).to have_content "#{beer.name}: #{score}"
      end
    end

    it "can not see ratings created by others on his/her page" do
      scores = [11, 13, 22, 14, 15, 16]
      beer = FactoryGirl.create :beer
      create_ratings *scores, FactoryGirl.create(:user, username:"Other"), beer

      visit user_path(@user)
      scores.each do |score|
        expect(page).not_to have_content "#{beer.name}: #{score}"
      end
    end

    it "will see his/her favourite beer, beer style and brewery on his/her page" do
      brewery = FactoryGirl.create(:brewery)
      beer = FactoryGirl.create(:beer, brewery:brewery)
      rating = FactoryGirl.create(:rating, user:@user, beer:beer)

      visit user_path(@user)
      expect(page).to have_content "favourite beer: #{beer}"
      expect(page).to have_content "favourite beer style: #{beer.style}"
      expect(page).to have_content "favourite brewery: #{brewery}"
    end
  end

  it "when signed up with good credentials, is added to the system" do
    visit signup_path
    fill_in('user_username', with:'Brian')
    fill_in('user_password', with:'Secret55')
    fill_in('user_password_confirmation', with:'Secret55')

    expect{
      click_button('Create User')
    }.to change{User.count}.by(1)
  end
end

