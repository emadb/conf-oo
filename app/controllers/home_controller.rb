class HomeController < ApplicationController
  before_filter :user_is_admin?, :except => [:index, :authenticate]

  def index
  	@page_class = 'home'
  end
  def authenticate
  	
  end
  def admin_area
  	
  end
end
