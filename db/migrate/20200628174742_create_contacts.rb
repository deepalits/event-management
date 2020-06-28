class CreateContacts < ActiveRecord::Migration[5.2]
  def change
    create_table :contacts do |t|
      t.bigint :phone_number
      t.integer :extension
      t.references :user
      t.timestamps
    end
  end
end
