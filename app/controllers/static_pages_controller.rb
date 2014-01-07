class StaticPagesController < ApplicationController
  def home
  	@name = request.get?
  end

  def help
  end

  def about
  end

  def contact
  end

end
