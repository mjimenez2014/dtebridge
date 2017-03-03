class ChangeDataTypeForMnttotalToDetlibros < ActiveRecord::Migration
  def change
  	change_column :detlibros, :mnttotal, :bigint, :precision => 0
  end
end
