require 'spec_helper'

include OwnTestHelper

describe "Rating" do
  let!(:style) {FactoryGirl.create :style}
  let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }
  let!(:beer1) { FactoryGirl.create :beer, name:"iso 3", brewery:brewery, style:style }
  let!(:beer2) { FactoryGirl.create :beer, name:"Karhu", brewery:brewery, style:style }
  let!(:user) { FactoryGirl.create :user }

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select('iso 3', from:'rating[beer_id]')
    fill_in('rating[score]', with:'15')

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end

  it "all ratings and their count should be shown" do
    scores = [11, 13, 22, 14, 15, 16]
    create_ratings *scores, user, beer1

    visit ratings_path
    expect(page).to have_content "total number of ratings: #{scores.size}"
    scores.each do |score|
      expect(page).to have_content "#{beer1.name}: #{score} #{user.username}"
    end
  end

  it "when destroyed, is removed from the database" do
    scores = [11, 13, 22, 14, 15, 16]
    create_ratings *scores, user, beer1

    visit user_path(user)

    expect {
      within('li', text: "22") do
        click_link 'delete'
      end
    }.to change{Rating.count}.from(6).to(5)
    expect(Rating.find_by score:22).to be(nil)
  end
end
