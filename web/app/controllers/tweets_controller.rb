# frozen_string_literal: true

class TweetsController < ApplicationController
  before_action :set_client, only: [:index, :timeline]

  def index
    @tweets = Tweet.all
  end

  def goiryoku
    tweet_wartime = Tweet.where(tweeted_at: Live.all.map { |live| live.start + 18.hours..live.end + 26.hours }).select(Tweet::WORD_CLASS)
    @goiryoku_wartime = calc(tweet_wartime)

    tweet_peacetime = Tweet.where.not(id: tweet_wartime.ids).select(Tweet::WORD_CLASS)
    @goiryoku_peacetime = calc(tweet_peacetime)
  end

  def timeline
    mecab = Natto::MeCab.new(dicdir: '/usr/local/lib/mecab/dic/mecab-ipadic-neologd')

    timelines = @client.list_timeline('sirka_p', 'アイマス情報源')
    @wakachi = []
    timelines.each do |t|
      text = t.text || t.attrs[:full_text]
      hash = {}
      mecab.enum_parse(text).each do |node|
        hash[node.surface] = node.feature.split(',')[0] unless node.is_eos?
      end
      @wakachi.push(hash)
    end
    @tweets = timelines
  end

  private

  def set_client
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
      config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
      config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
      config.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
    end
  end

  def calc(tweets)
    goiryoku = { count: tweets.size }
    Tweet::WORD_CLASS.each do |column|
      sum = tweets.sum(column)
      goiryoku[column] = { average: (sum / tweets.size.to_f).round(2), sum: sum }
    end

    goiryoku
  end
end
