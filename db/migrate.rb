class CreateTitles < ActiveRecord::Migration
  def self.up
    create_table :entries do |t|
      t.string :tag
      t.string :published
      t.string :updated
    end
  end

  def self.down
    drop_table :entries
  end

end
