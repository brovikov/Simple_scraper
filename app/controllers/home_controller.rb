# -*- encoding : utf-8 -*-
class HomeController < ApplicationController

  require 'nokogiri'
  require 'open-uri'

  def index
  end

  def search
    @search = params['q']
    page = open "http://www.google.com/search?q=#{@search}"
    html = Nokogiri::HTML page

    #open("search.html", "wb") do |file|
    # open "http://www.google.com/search?q=#{@search}" do |uri|
    #    file.write(uri.read)
    # end
    #end
    @ads_top = html.search('div#tads li cite')
    @ads_bottom  = html.search('div#tadsb li cite')
    @ads_right = html.search('table#mbEnd li cite')
    @ads_total = @ads_top.count+@ads_bottom.count+@ads_right.count
    @search_results = html.search("div#res li cite")
    @total_search_results = html.css('div#resultStats').inner_text.split(":").last
    @all_cite = html.search('cite')
  end
end
