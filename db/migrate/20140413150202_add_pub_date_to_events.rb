class AddPubDateToEvents < ActiveRecord::Migration
  def change
    add_column :events, :pubdate, :datetime
  end
end
