# frozen_string_literal: true

class TweetsController < ApplicationController
  before_action :set_client, only: [:index]

  def index
    @tweets = Tweet.page(params[:page])
  end

  def import
    puts params[:file]

    file = params[:file]

    if file.blank? || File.extname(file.original_filename).downcase != '.csv'
      flash.notice = 'CSVファイルを選択して下さい。'
      redirect_to tweets_path
      return
    end

    tmp_file = "tmp/csv/#{SecureRandom.uuid}.csv"
    File.open(tmp_file, "wb"){ |f| f.write(file.read) }
    MecabTweetJob.perform_later(tmp_file)

    flash.notice = 'CSVの取り込みを開始しました。しばらくお待ち下さい。'
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
