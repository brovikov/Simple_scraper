class KeywordsWorker
  include Sidekiq::Worker
  
  def perform
    if keyword = Keyword.new_records.first 
      page = open "http://www.google.com/search?q=#{keyword.phrase}" rescue nil
      html = Nokogiri::HTML page if page

      if html
        #It saves search result to file (for my manual tests) - commented in production
        #open("#{keyword.phrase}.html", "wb") do |file|
        #  open "http://www.google.com/search?q=#{keyword.phrase}" do |uri|
        #    file.write(uri.read)
        #  end
        #end
        %w[ads_top ads_bottom ads_right regular].each do |type|
          #Scraping links for top Google AdSense‎ links
          if type == 'ads_top'
            scraper = html.search('div#tads h3 a')# html.search('div#tads li cite') #html.search('div#tads h3 a')[0]['href']
            keyword.ads_top_total = scraper.count 
          end
          #Scraping links for bottom Google top AdSense‎ links
          if type == 'ads_bottom'
            scraper = html.search('div#tadsb h3 a') 
            keyword.ads_bottom_total = scraper.count 
          #Scraping links for right Google top AdSense‎ links
          end
          if type == 'ads_right'
            scraper = html.search('table#mbEnd h3 a') #html.search('table#mbEnd li cite')  #html.search('table#mbEnd h3 a')[7]['href']
            keyword.ads_right_total = scraper.count 
          end
          #Scraping search links 
          if type == 'regular'
            scraper = html.css("div#res li h3 a")#html.search("div#res li cite") #html.css("div#res li h3 a")[7]['href']
            keyword.search_on_page_total = scraper.count 
          end
          #Extract and build search links
          scraper.each do |link|
            keyword.links.build(url: link['href'], type: type)
          end
        end # end of each type
        keyword.ads_total = keyword.ads_right_total + keyword.ads_top_total + keyword.ads_bottom_total
        keyword.total_links = keyword.ads_total + keyword.search_on_page_total
        keyword.overall_total_search_res = html.css('div#resultStats').inner_text.split(":").last
        keyword.state = "completed"
      else
        keyword.state = "wrong" #in case of nil html
      end
      keyword.save
    end #end for if keyword
    #Restarting keyword worker if new_records scope not empty
    # it do this with randomly delay, hope this help us mislead G bot detector :)
    KeywordsWorker.perform_in((2+rand(3)).minutes) unless Keyword.new_records.blank?
  end 
end