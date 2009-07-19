class AddBarcodeFilenameToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :barcode_filename, :string
  end

  def self.down
    remove_column :products, :barcode_filename
  end
end
