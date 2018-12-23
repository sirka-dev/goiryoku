class Tweet < ApplicationRecord
  validates :tweet_id, uniqueness: true
  WORD_CLASS = [:length, :verb, :adjective, :noun, :pre_noun, :adverb, :conj, :symbol, :other].freeze
end
