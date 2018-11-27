# frozen_string_literal: true

class TweetsController < ApplicationController
  before_action :set_client, only: %i[index timeline]

  def index
    keyword = 'ruby'
    count = 10

    @tweets = @client.search("##{keyword}", count: count, lang: 'ja', result_type: 'recent', exclude: 'retweets', tweet_mode: 'extended').take(count)
  end

  def timeline
    timelines = @client.list_timeline('sirka_p', 'アイマス情報源')
    timelines.each do |t|
      tweet = Tweet.new(tweet_id: t.id, user_id: t.attrs[:user][:id], text: t.text || t.attrs[:full_text])
      tweet.save
    end
    @tweets = timelines
  end

  def set_client
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
      config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
      config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
      config.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
    end
  end
end
