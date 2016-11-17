class AddLibroreferenceToOtrosimpdetlibro < ActiveRecord::Migration
  def change
    add_reference :otrosimpdetlibros, :libro, index: true
  end
end
