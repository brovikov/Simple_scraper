class KeyWordsController < RocketPants::Base

  version 1

  # The list of keywords is paginated for 5 minutes, the keyword itself is cached
  # until it's modified (using Efficient Validation)
  caches :index, :show, :cache_for => 5.minutes

  def index
    expose Keyword.all.paginate(page: params[:page], per_page: 5)
  end

  def show
    expose Keyword.find(params[:id])
  end

  def link
    expose Link.find(params[:id])
  end

  def links
    expose Link.all.paginate(page: params[:page], per_page: 5)
  end

end