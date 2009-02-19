class AddAmazonIdAttributeToMovies < ActiveRecord::Migration
  def self.up
    add_column :movies, :amazon_id, :string
  end

  def self.down
    remove_column :movies, :amazon_id
  end
end
