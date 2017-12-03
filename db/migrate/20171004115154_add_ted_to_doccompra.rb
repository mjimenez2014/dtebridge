class AddTedToDoccompra < ActiveRecord::Migration
  def change
    add_column :doccompras, :TED, :text
  end
end
