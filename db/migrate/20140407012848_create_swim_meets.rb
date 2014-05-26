class CreateSwimMeets < ActiveRecord::Migration
  def change
    create_table :swim_meets do |t|
      t.string :title
      t.datetime :started_on
      t.datetime :finished_on
      t.string :courses
      t.string :location
      t.text :location_url
      t.text :results_url

      t.timestamps
    end
  end
end
