module OwnTestHelper

  def sign_in(credentials)
    visit signin_path
    fill_in('username', with:credentials[:username])
    fill_in('password', with:credentials[:password])
    click_button('Log in')
  end

  def create_ratings(*scores, user, beer)
    scores.each do |score|
      FactoryGirl.create :rating, user:user, beer:beer, score:score
    end
  end
end