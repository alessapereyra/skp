module BuyingOrdersHelper
  
  def print_input_type(input_order)
    input_order.input_type.capitalize unless input_order.input_type.blank? 
  end
  
end
