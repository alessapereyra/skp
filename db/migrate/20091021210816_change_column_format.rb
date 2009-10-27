class ChangeColumnFormat < ActiveRecord::Migration
  def self.up
		change_column :send_order_details, :quantity, :decimal, :precision => 10, :scale => 2
		change_column :sending_guide_details, :quantity, :decimal, :precision => 10, :scale => 2
		change_column :quote_details, :quantity, :decimal, :precision => 10, :scale => 2
  end

  def self.down
		change_column :quote_details, :quantity, :string
		change_column :sending_guide_details, :quantity, :string
		change_column :send_order_details, :quantity, :string
  end
end
