class AddMntSinCredToDetlibro < ActiveRecord::Migration
  def change
    add_column :detlibros, :mntsincred, :integer
  end
end
