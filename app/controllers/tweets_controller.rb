# frozen_string_literal: true

class TweetsController < ApplicationController
  before_action :set_client, only: [:index]

  def index
    @tweets = Tweet.page(params[:page])
  end

  def csv_parse
    MecabTweetJob.perform_later
    flash.notice = 'CSVの取り込みを開始しました'
    redirect_to root_path
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
end
