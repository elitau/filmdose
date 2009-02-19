class CreateHabtmTableForDirectorsMovies < ActiveRecord::Migration
  def self.up
    create_table :directors_movies, :id => false do |t|
      t.integer :director_id
      t.integer :movie_id
    end
  end

  def self.down
    drop_table :directors_movies
  end
end
