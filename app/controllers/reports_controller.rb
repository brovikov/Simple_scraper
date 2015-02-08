class ReportsController < ApplicationController
  def index
  	@keywords = Keyword.all
  end

  def show
  end
end
