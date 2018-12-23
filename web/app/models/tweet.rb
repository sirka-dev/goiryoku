class Tweet < ApplicationRecord
  validates :tweet_id, uniqueness: true

  scope :wartime, -> { where(tweeted_at: Live.all.map { |live| live.start + 18.hours..live.end + 26.hours }) }
  scope :peacetime, -> { where.not(tweeted_at: Live.all.map { |live| live.start + 18.hours..live.end + 26.hours }) }
  # TODO: peacetimeはwartimeのnotで書きたい
end
