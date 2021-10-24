class AddDeadlineCancelToProposal < ActiveRecord::Migration[6.1]
  def change
    add_column :proposals, :deadline_cancel, :date
  end
end
