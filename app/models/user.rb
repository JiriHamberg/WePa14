class User < ActiveRecord::Base
  include RatingAverage
  
  has_secure_password

  validates :username, uniqueness: true, length: { minimum: 3, maximum: 15 }
  validates :password, length: {minimum: 4},
   format: { with: /.*[A-Z].*/, message: 
    'must have at least one upper case letter (A-Z)' }


  has_many :ratings, :dependent => :destroy
  has_many :beers, through: :ratings
  has_many :memberships, :dependent => :destroy
  has_many :beer_clubs, through: :memberships

  def is_member_of(beer_club)
    memberships.any? { |membership| membership.beer_club == beer_club and membership.confirmed}
  end

  def favourite_beer
    return nil if ratings.empty?
    ratings.order(score: :desc).limit(1).last.beer
  end

  def favourite_style
    key_with_highest_average_by :style
  end

  def favourite_brewery
    key_with_highest_average_by :brewery
  end

  def self.active_raters(n)
    ratings_by_user = self.all.reduce({}) do |set, user|
      set[user] = user.ratings.size
      set
    end
    ratings_by_user.sort_by{|key, val| -val}.first(n).collect{|key, val| key}
  end

  private 

  def key_with_highest_average_by(beer_column)
    return nil if ratings.empty?

    averages_by_column = ratings.group_by{ |rating| rating.beer.send(beer_column)}.reduce({}) do |result, (key, ratings)|
      result[key] = ratings.collect(&:score).reduce(:+).to_f / ratings.size
      result
    end
    averages_by_column.max_by{ |key, avg| avg }.first
  end
end
