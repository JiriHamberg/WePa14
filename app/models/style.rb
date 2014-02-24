class Style < ActiveRecord::Base
  include RatingAverage
  
  has_many :beers
  has_many :ratings, :through => :beers

  def to_s
    "#{name}"
  end
end
