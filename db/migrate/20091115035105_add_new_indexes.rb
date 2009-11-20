## Drop this into a file in db/migrate ##
class AddNewIndexes < ActiveRecord::Migration
  def self.up
    
    # These indexes were found by searching for AR::Base finds on your application
    # It is strongly recommanded that you will consult a professional DBA about your infrastucture and implemntation before
    # changing your database in that matter.
    # There is a possibility that some of the indexes offered below is not required and can be removed and not added, if you require
    # further assistance with your rails application, database infrastructure or any other problem, visit:
    #
    # http://www.railsmentors.org
    # http://www.railstutor.org
    # http://guides.rubyonrails.org

    
#    add_index :quotes, :client_id
 #   add_index :quotes, :user_id
  #  add_index :quotes, :store_id
#    add_index :age_ranges, :quote_id
#    add_index :input_orders, :owner_id
#    add_index :input_orders, :provider_id
#    add_index :input_orders, :store_id
#    add_index :funds, :store_id
#    add_index :orders, :sending_guide_id
#    add_index :orders, :client_id
#    add_index :orders, :quote_id
#    add_index :orders, :store_id
#    add_index :send_orders, :owner_id
#    add_index :send_orders, :store_id
#    add_index :pages, :parent_id
#    add_index :products, :unit_id
#    add_index :exit_order_details, :product_id
#    add_index :users, :role_id
#    add_index :users, :store_id
#    add_index :sending_guides, :client_id
#    add_index :sending_guides, :store_id
#    add_index :categories, :product_id
    add_index :exit_orders, :client_id
    add_index :exit_orders, :store_id
  end
  
  def self.down
    remove_index :quotes, :client_id
    remove_index :quotes, :user_id
    remove_index :quotes, :store_id
    remove_index :age_ranges, :quote_id
    remove_index :input_orders, :owner_id
    remove_index :input_orders, :provider_id
    remove_index :input_orders, :store_id
    remove_index :funds, :store_id
    remove_index :orders, :sending_guide_id
    remove_index :orders, :client_id
    remove_index :orders, :quote_id
    remove_index :orders, :store_id
    remove_index :order_details, :client_id
    remove_index :send_orders, :owner_id
    remove_index :send_orders, :store_id
    remove_index :pages, :parent_id
    remove_index :products, :unit_id
    remove_index :exit_order_details, :product_id
    remove_index :users, :role_id
    remove_index :users, :store_id
    remove_index :sending_guides, :client_id
    remove_index :sending_guides, :store_id
    remove_index :categories, :product_id
    remove_index :exit_orders, :client_id
    remove_index :exit_orders, :store_id
  end
end

