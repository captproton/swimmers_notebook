class AddAssociationsToEffort < ActiveRecord::Migration
  def change
    add_column :efforts, :event_id, :integer
    add_column :efforts, :swim_meet_id, :integer
    add_column :efforts, :swimmer_id, :integer 
  end
end
