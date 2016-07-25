class AddCodinpToDetlibro < ActiveRecord::Migration
  def change
    add_column :detlibros, :codimp, :integer
    add_column :detlibros, :tasaimp, :float
    add_column :detlibros, :mntimp, :integer
  end
end
