class AddCustomerToOrders < ActiveRecord::Migration[5.2]
  def change
    add_reference :orders, :user, index: true
  end
end
