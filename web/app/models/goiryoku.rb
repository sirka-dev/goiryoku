class Goiryoku
  include ActiveModel::Model
  WORD_CLASS = [:word_total, :length, :verb, :adjective, :noun, :pre_noun, :adverb, :conj, :symbol, :other].freeze

  def self.wartime
    Tweet.wartime.select(WORD_CLASS)
  end

  def self.peacetime
    Tweet.peacetime.select(WORD_CLASS)
  end
end
