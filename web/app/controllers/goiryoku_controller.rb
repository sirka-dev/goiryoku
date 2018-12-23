class GoiryokuController < ApplicationController
  def index
    # nothing
  end

  def goiryoku
    @goiryoku_wartime = calc(Goiryoku.wartime)
    @goiryoku_peacetime = calc(Goiryoku.peacetime)
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
