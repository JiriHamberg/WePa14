class Brewery < ActiveRecord::Base
	include RatingAverage
	
  validates :name, presence: true
  validate :valid_year

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

end
