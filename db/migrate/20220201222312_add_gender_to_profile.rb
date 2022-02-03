class AddGenderToProfile < ActiveRecord::Migration[6.1]
  def change
    add_column :profiles, :gender, :integer, default: 0
  end
end
