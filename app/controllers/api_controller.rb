class ApiController < RocketPants::Base

  version 1

  # The list of keywords is paginated for 5 minutes, the food itself is cached
  # until it's modified (using Efficient Validation)
  caches :index, :show, :cache_for => 5.minutes

  def index
    expose Keyword.all#paginate(:page => params[:page])
  end

  def show
    expose Keyword.find(params[:id])
  end

end