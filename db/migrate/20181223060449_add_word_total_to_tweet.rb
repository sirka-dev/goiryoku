class AddWordTotalToTweet < ActiveRecord::Migration[5.2]
  def up
    add_column :tweets, :word_total, :integer, default: 0
  end

  def down
    remove_column :tweets, :word_total
  end
end
