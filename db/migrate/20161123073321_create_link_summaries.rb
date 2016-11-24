class CreateLinkSummaries < ActiveRecord::Migration
  def change
    create_table :link_summaries do |t|
      t.jsonb :raw
      t.string :type
      t.references :extracted_url, index: true

      t.timestamps null: false
    end
  end
end
