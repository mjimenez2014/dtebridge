class ChangeDataTypeForMnttotalToDocmanuals < ActiveRecord::Migration
  def change
  	change_column :docmanuals, :mnttotal, :bigint, :precision => 0
  end
end
