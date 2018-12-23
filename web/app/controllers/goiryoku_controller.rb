class GoiryokuController < ApplicationController
  def index
    # nothing
  end

  def goiryoku
    tweet_wartime = Tweet.where(tweeted_at: Live.all.map { |live| live.start + 18.hours..live.end + 26.hours }).select(Goiryoku::WORD_CLASS)
    @goiryoku_wartime = calc(tweet_wartime)

    tweet_peacetime = Tweet.where.not(id: tweet_wartime.ids).select(Goiryoku::WORD_CLASS)
    @goiryoku_peacetime = calc(tweet_peacetime)
  end

  private

  def calc(tweets)
    goiryoku = { count: tweets.size }
    Goiryoku::WORD_CLASS.each do |column|
      sum = tweets.sum(column)
      goiryoku[column] = { average: (sum / tweets.size.to_f).round(2), sum: sum }
    end

    goiryoku
  end
end
