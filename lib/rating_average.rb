module RatingAverage
  
  def self.included base
    base.send :include, InstanceMethods
    base.extend ClassMethods
  end

  module InstanceMethods
  	def average_rating
  		ratings.collect { |rating| rating.score }.inject(:+).to_f / ratings.size
  	end
  end

  module ClassMethods
    def top(n)
      avg_ratings = self.all.reduce({}) do |set, obj|
        set[obj] = obj.average_rating.nan? ? 0 : obj.average_rating
        set
      end
      avg_ratings.sort_by{|key, val| -val}.first(n).collect{|key, val| key}
    end
  end

end