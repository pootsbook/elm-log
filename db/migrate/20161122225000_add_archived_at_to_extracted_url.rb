class AddArchivedAtToExtractedUrl < ActiveRecord::Migration
  def change
    add_column :extracted_urls, :archived_at, :datetime, index: true
  end
end
