class AddIndexToCats < ActiveRecord::Migration[5.2]
  def change
      add_index :cats, :user_id
  end
end
