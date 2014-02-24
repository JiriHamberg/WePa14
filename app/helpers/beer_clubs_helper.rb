module BeerClubsHelper
  def is_member_of(beer_club)
    current_user.memberships.any? { |membership| membership.beer_club == beer_club and membership.confirmed}
  end

  def get_application(beer_club, user)
    user.memberships.each do |membership|
      return membership if membership.beer_club == beer_club and not membership.confirmed      
    end
    nil
  end

end
