class ReportsController < ApplicationController
  def index
    @keywords = Keyword.order(phrase: :asc)
  end

  def show
    @keyword = Keyword.find(params['id'])
  end
end
