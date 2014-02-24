class Brewery < ActiveRecord::Base
	include RatingAverage

  validates :name, presence: true
  validates :year, numericality: { less_than_or_equal_to: ->(_) { Time.now.year} }

  scope :active, -> { where active:true }
  scope :retired, -> { where active:[nil,false] }

  has_many :beers, :dependent => :destroy
  has_many :ratings, :through => :beers

  def print_report
    puts name
    puts "established at year #{year}"
    puts "number of beers #{beers.count}"
    puts "number of ratings #{ratings.count}"
  end

  def restart
    self.year = 2014
    puts "changed year to #{year}"
  end

  def valid_year
    year_now = Time.now.year
    if year < 1042 || year > year_now
      errors.add :year, "should be between 1042 and #{year_now}"
    end
  end

  def to_s
    "#{name}"
  end

  #def self.top(n)
  #  avg_ratings = self.all.reduce({}) do |set, brewery|
  #    set[brewery] = brewery.average_rating.nan? ? 0 : brewery.average_rating
  #    set
  #  end
  #  avg_ratings.sort_by{|key, val| -val}.first n
  #end

end
