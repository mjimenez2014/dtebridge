class AddOtrosImpToCompmanual < ActiveRecord::Migration
  def change
    add_column :compmanuals, :codimp, :integer
    add_column :compmanuals, :tasaimp, :float
    add_column :compmanuals, :mntimp, :integer
  end
end
