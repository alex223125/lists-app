class AddIndexToLists < ActiveRecord::Migration[7.0]
  def change
    add_index :lists, :is_public
  end
end
