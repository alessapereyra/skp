module QuoteHelper
  
  def quote_detail_price(quote_detail,price_type,product)
    
      if quote_detail.price.blank?
    
      price_type = "Corporativo" if price_type.blank?
    
       price_index = if price_type == "Mayorista"
                        2
                      elsif price_type == "Corporativo"
                        1
                      else
                        2 + current_store
                      end

         price = (product.all_current_prices[price_index])
         price = Price.new({:amount=> 0.0}) if price.blank?

         price.amount
        
      else
          quote_detail.price 
      end
    
  end
  
  
  
end
