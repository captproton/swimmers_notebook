class RemoveColumnFromEvents < ActiveRecord::Migration
  def change
    remove_column :events, :json_data, :json
  end
end
