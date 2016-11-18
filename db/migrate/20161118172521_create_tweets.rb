class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.string :twitter_id, null: false
      t.jsonb :raw, null: false
      t.boolean :processed, default: false, null: false

      t.timestamps null: false
    end
  end
end
