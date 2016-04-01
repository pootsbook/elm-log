class CreateIdentities < ActiveRecord::Migration
  def change
    create_table :identities do |t|
      t.string :uid
      t.string :provider
      t.string :name
      t.string :email
      t.string :image
      t.string :nickname
      t.string :first_name
      t.string :last_name
      t.string :description
      t.string :location
      t.string :phone
      t.text :raw

      t.timestamps null: false
    end
  end
end
