class CreateTweets < ActiveRecord::Migration[5.2]
  def change
    create_table :tweets do |t|
      t.string :tweet_id
      t.string :user_id
      t.text :text

      t.timestamps
    end
  end
end
