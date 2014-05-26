class AddSwimConnectionIdToSwimMeet < ActiveRecord::Migration
  def change
    add_column :swim_meets, :swimconnection_com_id, :string
  end
end
