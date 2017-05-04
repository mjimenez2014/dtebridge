class AddMntSinCredToCompmanual < ActiveRecord::Migration
  def change
    add_column :compmanuals, :mntsincred, :integer
  end
end
