class CreateAddresses < ActiveRecord::Migration[5.1]
  def change
    create_table :addresses do |t|
      t.string :nickname, default: "Home"
      t.string :address
      t.string :city
      t.string :state
      t.integer :zip
    end
  end
end
