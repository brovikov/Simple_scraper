# -*- encoding : utf-8 -*-
class KeywordsController < ApplicationController

  def import
    Keyword.import(params[:file])
    redirect_to root_url, notice: "Links imported."
  end

end
