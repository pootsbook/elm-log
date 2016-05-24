class CreateMeetupGroups < ActiveRecord::Migration
  def change
    create_table :meetup_groups do |t|
      t.text :description
      t.string :name
      t.string :city
      t.string :country
      t.string :url
      t.string :external_id
      t.string :utc_offset_fmt
      t.string :time_zone
      t.string :state
      t.string :urlname
      t.string :photo_highres
      t.string :photo
      t.string :photo_thumb
      t.integer :member_count
      t.integer :utc_offset
      t.datetime :external_created_at

      t.timestamps null: false
    end
  end
end
