class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :beer_club

  validate :one_membership_per_club

    def one_membership_per_club
      unless user.beer_clubs.find_by(id: beer_club.id).nil?
        errors.add :beer_club, "you are already a member of club #{beer_club}"
      end
    end

end
