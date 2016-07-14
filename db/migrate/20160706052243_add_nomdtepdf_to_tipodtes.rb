class AddNomdtepdfToTipodtes < ActiveRecord::Migration
  def change
  	add_column :tipodtes, :nomdtepdf, :string
  end
end
