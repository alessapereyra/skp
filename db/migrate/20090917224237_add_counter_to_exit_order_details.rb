class AddCounterToExitOrderDetails < ActiveRecord::Migration
  def self.up
    add_column :exit_orders, :exit_order_details_count, :integer, :default => 0
    
    # Order.reset_column_information
    # Order.find(:all).each do |p|
    #    Order.update_counters p.id, :exit_order_details_count => p.exit_order_details.length
    #  end
    
     execute 'update exit_orders, (select exit_order_id, count(*) as the_count from exit_order_details group by exit_order_id) as comm set exit_orders.exit_order_details_count = comm.the_count where exit_orders.id = comm.exit_order_id;     '
    
    
  end

  def self.down
    remove_column :exit_orders, :exit_order_details_count
  end
end
