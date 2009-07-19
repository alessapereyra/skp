class AddBuyingDateToProduct < ActiveRecord::Migration
  def self.up
    add_column :products, :buying_date, :date
      end

      def self.down
    remove_column :products, :buying_date
  end
end
