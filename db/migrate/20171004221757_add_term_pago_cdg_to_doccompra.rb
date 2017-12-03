class AddTermPagoCdgToDoccompra < ActiveRecord::Migration
  def change
    add_column :doccompras, :TermPagoCdg, :string
  end
end
