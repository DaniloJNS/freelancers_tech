class AddFeedbackToProposal < ActiveRecord::Migration[6.1]
  def change
    add_column :proposals, :feedback, :string
  end
end
