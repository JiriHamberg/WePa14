require 'spec_helper'

describe User do
  it "has the username set correctly" do
    user = User.new username:"Pekka"

    user.username.should == "Pekka"
  end

  it "is not saved without a password" do
    user = User.create username:"Pekka"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  describe "favourite beer" do
    let(:user){FactoryGirl.create(:user) }

    it "has method for determining one" do
      user.should respond_to :favourite_beer
    end

    it "without ratings does not have one" do
      expect(user.favourite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = create_beer_with_rating(10, user)

      expect(user.favourite_beer).to eq(beer)
    end

    it "is the one with highest rating if several rated" do
      create_beers_with_ratings(10, 20, 15, 7, 9, user)
      best = create_beer_with_rating(25, user)

      expect(user.favourite_beer).to eq(best)
    end
  end

  describe "with a proper password" do
    let(:user){ FactoryGirl.create(:user) }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do
      user.ratings << FactoryGirl.create(:rating)
      user.ratings << FactoryGirl.create(:rating2)

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end

  describe "with an invalid password" do
    it "is not saved if password is too short" do
      user = User.create username:"Pekka", password:"Et1", password_confirmation:"Et1"
     
      expect(user).not_to be_valid
      expect(User.count).to eq(0)
    end

    it "is not saved if password does not contain an upper case letter" do
      user = User.create username:"Pekka", password:"secret1", password_confirmation:"secret1"
     
      expect(user).not_to be_valid
      expect(User.count).to eq(0)
    end
  end

  describe "favourite style" do
    let(:user) { FactoryGirl.create(:user) }

    it "has a method for determining one" do
      user.should respond_to :favourite_style
    end

    it "should return nil if no ratings are given" do
      expect(user.favourite_style).to eq(nil)
    end

    it "should return the style of the only rated beer" do
      style = "IPA"
      create_beer_with_rating_of_style(11, user, style)
      expect(user.favourite_style).to eq(style)
    end

    it "should return the style with highest average ratings by the user" do
      best_style = "Pale Ale"
      create_beers_with_ratings_of_style(2, 15, 5, 8, 14, 3, 9, user, "Lager")
      create_beers_with_ratings_of_style(10, 20, 25, 9, user, best_style)
      create_beers_with_ratings_of_style(5, 24, 20, 14, 8, user, "IPA")

      expect(user.favourite_style).to eq(best_style)
    end
  end

  describe "favourite brewery" do
    let(:user) { FactoryGirl.create(:user) }
    let(:best_brewery) { FactoryGirl.create(:brewery) }


    it "has a method for determining one" do
      user.should respond_to :favourite_brewery
    end

    it "should return nil if no ratings are given" do
      expect(user.favourite_brewery).to eq(nil)
    end

    it "should return the brewery of the only rated beer" do
      create_beer_with_rating_of_brewery(12, user, best_brewery)

      expect(user.favourite_brewery).to eq(best_brewery)
    end

    it "should return the brewery with highest average ratings by the user" do
      brewery1 = FactoryGirl.create(:brewery, name: "Poor Brewery")
      brewery2 = FactoryGirl.create(:brewery, name: "Another Poor Brewery")
      create_beers_with_ratings_of_brewery(2, 15, 5, 8, 14, 3, 9, user, brewery1)
      create_beers_with_ratings_of_brewery(10, 20, 25, 9, user, best_brewery)
      create_beers_with_ratings_of_brewery(5, 24, 20, 14, 8, user, brewery2)

      expect(user.favourite_brewery).to eq(best_brewery)
    end
  end

end

def create_beer_with_rating(score, user)
  beer = FactoryGirl.create(:beer)
  FactoryGirl.create(:rating, score:score, beer:beer, user:user)
  beer
end

def create_beers_with_ratings(*scores, user)
  scores.each do |score|
    create_beer_with_rating(score, user)
  end
end

def create_beer_with_rating_of_style(score, user, style)
  beer = FactoryGirl.create(:beer, style:style)
  FactoryGirl.create(:rating, score:score, beer:beer, user:user)
  beer
end

def create_beers_with_ratings_of_style(*scores, user, style)
  scores.each do |score|
    create_beer_with_rating_of_style(score, user, style)
  end
end

def create_beer_with_rating_of_brewery(score, user, brewery)
  beer = FactoryGirl.create(:beer, brewery:brewery)
  FactoryGirl.create(:rating, score:score, beer:beer, user:user)
  beer
end

def create_beers_with_ratings_of_brewery(*scores, user, brewery)
  scores.each do |score|
    create_beer_with_rating_of_brewery(score, user, brewery)
  end
end