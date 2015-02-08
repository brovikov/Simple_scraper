# -*- encoding : utf-8 -*-
class KeywordsController < ApplicationController

  before_action :authenticate_user!

  def import
    Keyword.import(params[:file])
    redirect_to root_url, notice: "Links imported."
  end

end
