class AddCounterToOrderDetails < ActiveRecord::Migration
  def self.up
    add_column :orders, :order_details_count, :integer, :default => 0
    
    # Order.reset_column_information
    # Order.find(:all).each do |p|
    #    Order.update_counters p.id, :order_details_count => p.order_details.length
    #  end
    
     execute 'update orders, (select order_id, count(*) as the_count from order_details group by order_id) as comm set orders.order_details_count = comm.the_count where orders.id = comm.order_id;     '
    
    
  end

  def self.down
    remove_column :orders, :order_details_count
  end
end
