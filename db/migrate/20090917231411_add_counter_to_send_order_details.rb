class AddCounterToSendOrderDetails < ActiveRecord::Migration
  def self.up
    add_column :send_orders, :send_order_details_count, :integer, :default => 0
    
    # Order.reset_column_information
    # Order.find(:all).each do |p|
    #    Order.update_counters p.id, :send_order_details_count => p.send_order_details.length
    #  end
    
     execute 'update send_orders, (select send_order_id, count(*) as the_count from send_order_details group by send_order_id) as comm set send_orders.send_order_details_count = comm.the_count where send_orders.id = comm.send_order_id;     '
    
    
  end

  def self.down
    remove_column :send_orders, :send_order_details_count
  end
end
