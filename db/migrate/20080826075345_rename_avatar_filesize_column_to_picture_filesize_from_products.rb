class RenameAvatarFilesizeColumnToPictureFilesizeFromProducts < ActiveRecord::Migration
  
  def self.up
    rename_column :products, :avatar_filesize, :picture_filesize
  end

  def self.down
    rename_column :products, :picture_filesize, :avatar_filesize
  end
end
