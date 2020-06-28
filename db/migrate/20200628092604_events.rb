class Events < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.string    :title, null: false
      t.boolean   :all_day
      t.text      :description
      t.datetime  :start_datetime, null: false
      t.datetime  :end_datetime, null: false
      t.timestamps
    end
  end
end
