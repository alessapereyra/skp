class AddCounterToInputOrderDetails < ActiveRecord::Migration
  def self.up
    add_column :input_orders, :input_order_details_count, :integer, :default => 0
    
    # Order.reset_column_information
    # Order.find(:all).each do |p|
    #    Order.update_counters p.id, :input_order_details_count => p.input_order_details.length
    #  end
    
     execute 'update input_orders, (select input_order_id, count(*) as the_count from input_order_details group by input_order_id) as comm set input_orders.input_order_details_count = comm.the_count where input_orders.id = comm.input_order_id;     '
    
    
  end

  def self.down
    remove_column :input_orders, :input_order_details_count
  end
end
