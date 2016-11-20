class CreateExtractedUrls < ActiveRecord::Migration
  def change
    create_table :extracted_urls do |t|
      t.string :url, null: false
      t.references :source, polymorphic: true, index: true
      t.belongs_to :canonical_url, index: true

      t.timestamps null: false
    end
  end
end
