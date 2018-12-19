class AddToCats < ActiveRecord::Migration[5.2]
  def change
    add_column :cats, :user_id, :integer, null: false
  end
end
