class BeerClub < ActiveRecord::Base
  has_many :memberships, :dependent => :destroy
  has_many :users, through: :memberships


  def confirmed_members
    memberships.collect {|membership| membership.user if membership.confirmed }.compact
  end

  def applied_members
    memberships.collect {|membership| membership.user unless membership.confirmed }.compact
  end

  def to_s
    "#{name}"
  end
end
