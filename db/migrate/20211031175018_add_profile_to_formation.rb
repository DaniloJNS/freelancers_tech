class AddProfileToFormation < ActiveRecord::Migration[6.1]
  def change
    add_reference :formations, :profile, null: false, foreign_key: true
  end
end
