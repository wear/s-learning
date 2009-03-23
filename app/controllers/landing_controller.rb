class LandingController < BaseController
  def index
    @groups = Group.find(:all)
  end
end
