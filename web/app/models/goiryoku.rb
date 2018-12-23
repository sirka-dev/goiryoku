class Goiryoku
  include ActiveModel::Model
  WORD_CLASS = [:length, :verb, :adjective, :noun, :pre_noun, :adverb, :conj, :symbol, :other].freeze
end
