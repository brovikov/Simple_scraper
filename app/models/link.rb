class Link < ActiveRecord::Base

  TYPES = %w(ads_top ads_bottom ads_right regular broken)

  self.inheritance_column = :_type_disabled

  scope :ads_top_list, -> { where(type: %w(ads_top)) }
  scope :ads_bottom_list, -> { where(type: %w(ads_bottom)) }
  scope :ads_right_list, -> { where(type: %w(ads_right)) }
  scope :search_list, -> { where(type: %w(regular)) }

  belongs_to :keyword

  after_create :update_urls

  TYPES.each do |type|
    define_method("#{type}?") do
      self.type == type
    end
  end

  private

  def update_urls
    # Cut off Google url magick :) and trying to get a real url of the link
    url = self.url[/(((ftp|https?):\/\/)(www\.)?|www\.)([\da-z-_\.]+)([a-z\.]{2,7})([\/\w\.-]*)*\/?/]
    self.update_attributes(url: url)
  end
end
