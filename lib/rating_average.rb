module RatingAverage
	def average_rating
		ratings.collect { |rating| rating.score }.inject(:+).to_f / ratings.size
	end
end