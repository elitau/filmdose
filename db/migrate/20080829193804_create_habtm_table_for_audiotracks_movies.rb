class CreateHabtmTableForAudiotracksMovies < ActiveRecord::Migration
  def self.up
    create_table :audiotracks_movies, :id => false do |t|
      t.integer :audiotrack_id
      t.integer :movie_id
    end
  end

  def self.down
    drop_table :audiotracks_movies
  end
end
