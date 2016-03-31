class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.text :description
      t.string :country
      t.string :city
      t.string :host
      t.string :url
      t.string :external_id
      t.string :external_updated_at
      t.string :utc_offset_fmt
      t.integer :utc_offset
      t.datetime :starts_at

      t.timestamps null: false
    end
  end
end
