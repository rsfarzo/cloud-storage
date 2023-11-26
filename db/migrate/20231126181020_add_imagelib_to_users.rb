class AddImagelibToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :carrier_img, :string
  end
end
