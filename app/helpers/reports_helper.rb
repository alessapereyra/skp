#  height                    :decimal(10, 2)
#  width                     :decimal(10, 2)
#  weight                    :decimal(10, 2)
#  length                    :decimal(10, 2)

module ReportsHelper
  
 def total_volume(send_order)
  
  total = 0
  space = 0
  
  if send_order.is_a? SendOrder

    send_order.send_order_details.each do |sod|
      
      height = sod.product.height 
      width = sod.product.width 
      length =sod.product.length
      
      space = height * width * length unless (height.nil? || width.nil? || length.nil?)
      total += space * sod.quantity
      
    end
      
  elsif send_order.is_a? SendingGuide
    
    send_order.sending_guide_details.each do |sgd|
      
      height = sgd.product.height
      width = sgd.product.width
      length =sgd.product.length 
      
      space = height * width * length unless (height.nil? || width.nil? || length.nil?)
      total += space * sgd.quantity
      
    end   
    
  end
    #esta en centimetros, pasar a metros
   (total / 1000000).to_f.round(2)
  
 end
  
end