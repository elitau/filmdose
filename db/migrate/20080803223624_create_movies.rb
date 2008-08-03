class CreateMovies < ActiveRecord::Migration
  def self.up
    create_table :movies do |t|
      t.string :title
      t.integer :director_id
      t.text :description
      t.date :release_date
      t.integer :length
      t.string :extras

      t.timestamps
    end
  end

  def self.down
    drop_table :movies
  end
end
