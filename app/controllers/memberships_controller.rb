class MembershipsController < ApplicationController
  before_action :set_membership, only: [:show, :edit, :update, :destroy]
  before_action :set_beer_clubs, only: [:new, :create]
  # GET /memberships
  # GET /memberships.json
  def index
    @memberships = Membership.all
  end

  # GET /memberships/1
  # GET /memberships/1.json
  def show
  end

  # GET /memberships/new
  def new
    @membership = Membership.new
  end

  # GET /memberships/1/edit
  def edit
  end

  def confirm_membership
    id = params[:id]
    m = Membership.find_by id: id
    m.update_attribute(:confirmed, true) if m and current_user.is_member_of(m.beer_club)
    redirect_to :back
  end

  # POST /memberships
  # POST /memberships.json
  def create
    @membership = Membership.new(membership_params)
    if current_user.nil?
      redirect_to :back, notice: 'You need to logged in to join a club!'
    else    
      @membership.user_id = current_user.id

      respond_to do |format|
        if @membership.save
          format.html { redirect_to @membership.beer_club, notice: "#{@membership.user.username}, welcome to the club!" }
          format.json { render action: 'show', status: :created, location: @membership }
        else
          format.html { render action: 'new' }
          format.json { render json: @membership.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /memberships/1
  # PATCH/PUT /memberships/1.json
  def update
    respond_to do |format|
      if @membership.update(membership_params)
        format.html { redirect_to @membership, notice: 'Membership was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /memberships/1
  # DELETE /memberships/1.json
  def destroy
    @membership.destroy
    respond_to do |format|
      format.html { redirect_to memberships_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_membership
      @membership = Membership.find(params[:id])
    end

    def set_beer_clubs
      @beer_clubs = BeerClub.all
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def membership_params
      params.require(:membership).permit(:beer_club_id)
    end
end
