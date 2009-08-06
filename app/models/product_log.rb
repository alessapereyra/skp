# == Schema Information
#
# Table name: product_logs
#
#  id                 :integer(4)      not null, primary key
#  product_logs_id    :integer(4)
#  product_id         :integer(4)
#  controller         :string(255)
#  method             :string(255)
#  last_stock         :decimal(10, 2)
#  last_stock_trigal  :decimal(10, 2)
#  last_stock_polo    :decimal(10, 2)
#  last_stock_almacen :decimal(10, 2)
#  last_stock_clarisa :decimal(10, 2)
#  stock              :decimal(10, 2)
#  stock_trigal       :decimal(10, 2)
#  stock_polo         :decimal(10, 2)
#  stock_almacen      :decimal(10, 2)
#  stock_clarisa      :decimal(10, 2)
#  created_at         :datetime
#  updated_at         :datetime
#

class ProductLog < ActiveRecord::Base
  
  def self.report_for(id = nil,limit = 10)
    
    if id.nil? or id.zero?
      @products_log = ProductLog.find(:all, :order=>"created_at DESC", :limit => limit)
    else
      @products_log = ProductLog.find_all_by_product_id(id, :order=>"created_at DESC", :limit => limit)
    end
    
    puts "------------------------------------------------------------------------------------------------------------------------"
    puts "| id |  controller |  method  |     stock     |   trigal    |    polo       |  almacen     |  clarisa      |    date    |"    

    @products_log.map do |pl|
      
      pl.last_stock ||= 0.0
      pl.last_stock_trigal ||= 0.0
      pl.last_stock_polo ||= 0.0
      pl.last_stock_almacen ||= 0.0
      pl.last_stock_clarisa ||= 0.0
      pl.stock ||= 0.0
      pl.stock_trigal ||= 0.0
      pl.stock_polo ||= 0.0
      pl.stock_almacen ||= 0.0
      pl.stock_clarisa ||= 0.0
      pl.method ||= "method"
      pl.controller ||= "controller"
      
      puts "| #{pl.product_id} | #{pl.controller}  |  #{pl.method}  |  #{pl.last_stock} - #{pl.stock}  |  #{pl.last_stock_trigal} - #{pl.stock_trigal}  |  #{pl.last_stock_polo}  -  #{pl.stock_polo}  |  #{pl.last_stock_almacen} -  #{pl.stock_almacen}  |  #{pl.last_stock_clarisa}  -  #{pl.stock_clarisa}  |  #{ pl.created_at }  |"  
      
    end
    
    puts "------------------------------------------------------------------------------------------------------------------------"
    
  end
  
  
end
