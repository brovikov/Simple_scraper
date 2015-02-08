class Keyword < ActiveRecord::Base
  include RocketPants::Cacheable
  require 'nokogiri'
  require 'open-uri'
  require 'csv'

  STATES = %w(new completed wrong)  

  has_many :links

  scope :new_records, -> { where(state: %w(new)) }

  def self.import(file)
    worker_starter = true if Keyword.new_records.blank?
    CSV.foreach(file.path, headers: false) do |row|
      Keyword.create(phrase: row.first.squish.tr(" ", "+")) 
      # It removes all whitespace on both ends of the string, 
      # and then changing remaining consecutive whitespace groups 
      # into one space each and replace with + for multi words searches
      # Hope it will enough to get right search url for G :)
    end
    KeywordsWorker.perform_async #if worker_starter
  end

  STATES.each do |state|
    define_method("#{state}?") do
      self.state == state
    end
  end
end
