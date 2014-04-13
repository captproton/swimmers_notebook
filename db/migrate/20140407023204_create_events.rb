class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.text :results_url
      t.text :raw_text
      t.json :json_data,               default: {}, null: false
      t.belongs_to :swim_meet
      t.timestamps
    end
  end
end
