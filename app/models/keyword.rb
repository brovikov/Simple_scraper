class Keyword < ActiveRecord::Base
  require 'nokogiri'
  require 'open-uri'
  require 'csv'

  STATES = %w(new completed wrong)  

  has_many :links

  scope :new_records, -> { where(state: %w(new)) }

  before_create :search_scraping

  def self.import(file)
    CSV.foreach(file.path, headers: false) do |row|
      Keyword.create(phrase: row.first.squish.tr(" ", "+")) 
      # It removes all whitespace on both ends of the string, 
      # and then changing remaining consecutive whitespace groups 
      # into one space each and replace with + for multi words searches
      # Hope it will enough to get right search url for G :)
    end
  end

  STATES.each do |state|
    define_method("#{state}?") do
      self.state == state
    end
  end

  protected

  def search_scraping
    page = open "http://www.google.com/search?q=#{self.phrase}" rescue nil
    html = Nokogiri::HTML page if page

    if html
      #It saves search result to file (for my manual tests)
      #open("#{self.phrase}.html", "wb") do |file|
      #  open "http://www.google.com/search?q=#{self.phrase}" do |uri|
      #    file.write(uri.read)
      #  end
      #end


      %w[ads_top ads_bottom ads_right regular].each do |type|
        #Scraping links for top Google AdSense‎ links
        if type == 'ads_top'
          scraper = html.search('div#tads h3 a')# html.search('div#tads li cite') #html.search('div#tads h3 a')[0]['href']
          self.ads_top_total = scraper.count 
        end
        #Scraping links for bottom Google top AdSense‎ links
        if type == 'ads_bottom'
          scraper = html.search('div#tadsb h3 a') 
          self.ads_bottom_total = scraper.count 
        #Scraping links for right Google top AdSense‎ links
        end
        if type == 'ads_right'
          scraper = html.search('table#mbEnd h3 a') #html.search('table#mbEnd li cite')  #html.search('table#mbEnd h3 a')[7]['href']
          self.ads_right_total = scraper.count 
        end
        #Scraping search links 
        if type == 'regular'
          scraper = html.css("div#res li h3 a")#html.search("div#res li cite") #html.css("div#res li h3 a")[7]['href']
          self.search_on_page_total = scraper.count 
        end
        #Extract and build search links
        scraper.each do |link|
          self.links.build(url: link['href'], type: type)
        end
      end # end of each type
      self.ads_total = self.ads_right_total + self.ads_top_total + self.ads_bottom_total
      self.total_links = self.ads_total + self.search_on_page_total
      self.overall_total_search_res = html.css('div#resultStats').inner_text.split(":").last
      self.state = "completed"
    else
      self.state = "wrong"
    end
  end
end
