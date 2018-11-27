class TweetsController < ApplicationController
  def index
    client = Twitter::REST::Client.new do |config|
      config.consumer_key    = ENV['TWITTER_CONSUMER_KEY']
      config.consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
    end

    keyword = 'ruby'
    count = 10

    @tweets = client.search("##{keyword}", count: count, lang: 'ja', result_type: 'recent', exclude: 'retweets')
  end
end
