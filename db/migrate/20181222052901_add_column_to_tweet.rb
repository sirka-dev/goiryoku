class AddColumnToTweet < ActiveRecord::Migration[5.2]
  def up
    add_column :tweets, :length, :integer, default: 0
    add_column :tweets, :verb, :integer, default: 0
    add_column :tweets, :adjective, :integer, default: 0
    add_column :tweets, :noun, :integer, default: 0
    add_column :tweets, :pre_noun, :integer, default: 0
    add_column :tweets, :adverb, :integer, default: 0
    add_column :tweets, :conj, :integer, default: 0
    add_column :tweets, :symbol, :integer, default: 0
    add_column :tweets, :other, :integer, default: 0
  end

  def down
    remove_column :tweets, :length, :integer, default: 0
    remove_column :tweets, :verb, :integer, default: 0
    remove_column :tweets, :adjective, :integer, default: 0
    remove_column :tweets, :noun, :integer, default: 0
    remove_column :tweets, :pre_noun, :integer, default: 0
    remove_column :tweets, :adverb, :integer, default: 0
    remove_column :tweets, :conj, :integer, default: 0
    remove_column :tweets, :symbol, :integer, default: 0
    remove_column :tweets, :other, :integer, default: 0
  end
end
