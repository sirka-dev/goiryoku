class AddCategoryToLive < ActiveRecord::Migration[5.2]
  def up
    add_column :lives, :category, :string
  end
end
