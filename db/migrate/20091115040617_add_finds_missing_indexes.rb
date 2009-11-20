class AddFindsMissingIndexes < ActiveRecord::Migration
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
  
    add_index :quotes, :status
    add_index :pages, :title
    add_index :exit_orders, [:status, :store_id]
  end

  def self.down
    remove_index :quotes, :id
    remove_index :quotes, :status
    remove_index :input_order_details, :id
    remove_index :age_ranges, :id
    remove_index :quote_details, :id
    remove_index :brands, :id
    remove_index :units, :id
    remove_index :providers, :id
    remove_index :input_orders, :id
    remove_index :orders, :id
    remove_index :funds, :id
    remove_index :sending_guide_details, :id
    remove_index :pages, :id
    remove_index :pages, :title
    remove_index :order_details, :id
    remove_index :products, :id
    remove_index :send_orders, :id
    remove_index :stores, :id
    remove_index :expenses, :id
    remove_index :exit_order_details, :id
    remove_index :users, :id
    remove_index :send_order_details, :id
    remove_index :categories, :id
    remove_index :sending_guides, :id
    remove_index :product_logs, :id
    remove_index :roles, :id
    remove_index :prices, :id
    remove_index :options, :id
    remove_index :clients, :id
    remove_index :exit_orders, :id
    remove_index :exit_orders, :column => [:store_id, :status]
    remove_index :exit_orders, :column => [:status, :store_id]
  end
end

