require 'csv'

class MecabTweetJob < ApplicationJob
  queue_as :default

  def perform(*args)
    csv_data = CSV.read("#{Rails.root}/public/tweet.csv")
    csv_data.take(10).each do |data|
      next if data[2] =~ /^(@|RT )/

      tweet = Tweet.new(tweet_id: data[0], tweeted_at: DateTime.strptime(data[1]+' +09:00', '%y%m%d %H%M%S %z'), text: data[2])
      tweet.save
    end
  end
end
