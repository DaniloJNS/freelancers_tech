class AddReferencesToProposal < ActiveRecord::Migration[6.1]
  def change
    add_reference :proposals, :professional, null: false, foreign_key: true
    add_reference :proposals, :project, null: false, foreign_key: true
  end
end
