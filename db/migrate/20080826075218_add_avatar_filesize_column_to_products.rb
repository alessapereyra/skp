class AddAvatarFilesizeColumnToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :avatar_filesize, :integer
  end

  def self.down
    remove_column :products, :avatar_filesize
  end
end
