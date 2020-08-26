class ChangeModeratorColumnName < ActiveRecord::Migration[6.0]
  def change
    rename_column :subs, :moderator, :moderator_id
  end
end
