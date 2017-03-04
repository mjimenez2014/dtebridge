class AddTrackidSiiToUsers < ActiveRecord::Migration
  def change
    add_column :users, :trackidSII, :string
  end
end
