class AddIndexToContribuyente < ActiveRecord::Migration
  def change
    add_index :contribuyentes, :rut
  end
end
