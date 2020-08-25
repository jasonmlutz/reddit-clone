class CreateSubs < ActiveRecord::Migration[6.0]
  def change
    create_table :subs do |t|

      t.timestamps
    end
  end
end
