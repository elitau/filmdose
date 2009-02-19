class CreateAudiotracks < ActiveRecord::Migration
  def self.up
    create_table :audiotracks do |t|
      t.string :language
      t.string :format

      t.timestamps
    end
  end

  def self.down
    drop_table :audiotracks
  end
end
