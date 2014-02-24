class RatingsController < ApplicationController
	def index
		@rating_count = Rating.all.size
    @active_raters = User.active_raters 3
    @best_breweries = Brewery.top 3
    @best_beers = Beer.top 3
    @best_styles = Style.top 3
    @recent = Rating.recent 5
	end

	def new
    	@rating = Rating.new
    	@beers = Beer.all
  	end

  	def create
      if current_user.nil?
        redirect_to :back, notice: 'you need to signin to make a rating'
      else
    		@rating = Rating.create params.require(:rating).permit(:score, :beer_id)
        if @rating.save
          current_user.ratings << @rating
    		  redirect_to current_user
        else
          @beers = Beer.all
          render :new
        end
      end
  	end

  	def destroy
	    rating = Rating.find(params[:id])
	    rating.delete if current_user == rating.user
	    redirect_to :back
	end
end