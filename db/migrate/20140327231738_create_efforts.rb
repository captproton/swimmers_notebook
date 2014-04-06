class CreateEfforts < ActiveRecord::Migration
  def change
    create_table :efforts do |t|
      t.string :name
      t.string :age
      t.datetime :pubdate
    end
  end
end
