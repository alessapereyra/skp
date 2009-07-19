class ExpensesController < ApplicationController

  def admin_expenses

    # SOLO EFECTIVO

    if get_current_store == 4
      
      @orders = Order.find(:all, :order=>"number DESC", :conditions=>"credit_card like 'Efectivo' and type not like 'nota_de_credito' and status LIKE 'accepted' and order_date >= '#{@time_from}' and order_date < '#{@time_to+1.day}' ")    
      @visa_orders = Order.find(:all, :order=>"number DESC", :conditions=>"credit_card like 'VISA' and type not like 'nota_de_credito' and status LIKE 'accepted' and order_date >= '#{@time_from}' and order_date < '#{@time_to+1.day}' ")    
      @mastercard_orders = Order.find(:all, :order=>"number DESC", :conditions=>"credit_card like 'Mastercard' and type not like 'nota_de_credito' and status LIKE 'accepted' and order_date >= '#{@time_from}' and order_date < '#{@time_to+1.day}' ")    

        #@yesterday_orders = Order.find(:all, :order=>"order_date DESC", :conditions=>"credit_card like 'Efectivo' and type not like 'nota_de_credito' and status LIKE 'accepted' and order_date >= '#{@time_from - 1.day }' and order_date < '#{@time_to}' ")    
    else
      @orders = Order.find(:all, :order=>"number DESC", :conditions=>"credit_card like 'Efectivo' and type not like 'nota_de_credito' and status LIKE 'accepted' and order_date >= '#{@time_from}' and order_date < '#{@time_to+1.day}' and store_id=#{get_current_store} ")    
      @visa_orders = Order.find(:all, :order=>"number DESC", :conditions=>"credit_card like 'VISA' and type not like 'nota_de_credito' and status LIKE 'accepted' and order_date >= '#{@time_from}' and order_date < '#{@time_to+1.day}' and store_id=#{get_current_store} ")    
      @mastercard_orders = Order.find(:all, :order=>"number DESC", :conditions=>"credit_card like 'Mastercard' and type not like 'nota_de_credito' and status LIKE 'accepted' and order_date >= '#{@time_from}' and order_date < '#{@time_to+1.day}' and store_id=#{get_current_store} ")    

      #@yesterday_orders = Order.find(:all, :order=>"order_date DESC", :conditions=>"credit_card like 'Efectivo' and type not like 'nota_de_credito' and status LIKE 'accepted' and order_date >= '#{@time_from - 1.day }' and order_date < '#{@time_to}' and store_id=#{get_current_store} ")    
      
      end  
      

    @totals = 0.0
    @orders.each do |order| @totals += order.price end
    #@yesterday_orders.each do |order| @yesterday_total += order.price end
    return @totals #, @yesterday_total
    
  end
  
  def salesman_expenses
    
    @orders = Order.find(:all, :order=>"number DESC",
                         :conditions=>"credit_card like 'Efectivo' and type not like 'nota_de_credito' and status LIKE 'accepted' and order_date >= '#{@time_from}' and order_date < '#{@time_to+1.day}' and store_id=#{get_current_store} ")    
    @visa_orders = Order.find(:all, :order=>"number DESC", :conditions=>"credit_card like 'VISA' and type not like 'nota_de_credito' and status LIKE 'accepted' and order_date >= '#{@time_from}' and order_date < '#{@time_to+1.day}' and store_id=#{get_current_store} ")    
    @mastercard_orders = Order.find(:all, :order=>"number DESC", :conditions=>"credit_card like 'Mastercard' and type not like 'nota_de_credito' and status LIKE 'accepted' and order_date >= '#{@time_from}' and order_date < '#{@time_to+1.day}' and store_id=#{get_current_store} ")
    
   
    @totals = 0.0
    @orders.each do |order| @totals += order.price end

    return @totals
    
  end
  
  def setup_fund
    
    @fund = Fund.todays_fund(get_current_store)
    @fund.net_income = Fund.yesterday_fund(get_current_store).cash_amount + @totals - @total_expenses
    @fund.cash_amount = @fund.net_income - @fund.widthdrawal
    @fund.save!
    
  end

  def index
    
      # SOLO TE TOMAN EN CUENTA ORDENES EN EFECTIVO
      # SE COGE EL SALDO DEL DIA ANTERIOR, Y SE RESTA DEL DE HOY
      # NO SE INCLUYEN NOTAS DE CREDITO
      
      @expense = Expense.new
      
      @time_from = @time_to = Date.new(Time.zone.now.year,Time.zone.now.month,Time.zone.now.day)
      
      @mastercard_orders = @visa_orders = []
      
      if admin? 
    
        admin_expenses

      else
    
        salesman_expenses

      end
      
      
      @expenses = Expense.find(:all, :order=>"expense_date DESC", :conditions=>"store_id = #{get_current_store} and expense_date >= '#{Time.zone.now}' and expense_date < '#{Time.zone.now+1.day}'")
      @total_expenses = 0.0
      @visa_total = @mastercard_total = 0.0
      @mastercard_total = @mastercard_orders.inject(0.0){|sum,o| sum + o.price }
      
      @visa_total = @visa_orders.inject(0.0){|sum,o| sum + o.price }
            
      @expenses.each do |e| @total_expenses += e.amount unless e.amount.nil? end
      @yesterday_fund = Fund.yesterday_fund(get_current_store)
      setup_fund
      
    
  end
  
  def create

    @time_from = @time_to = Date.new(Time.zone.now.year,Time.zone.now.month,Time.zone.now.day)    
    @expense = Expense.create(params[:expense])
    @expense.expense_date = Time.zone.now
    @expense.store_id = get_current_store
     if admin? 
    
        admin_expenses

      else
    
        salesman_expenses

      end
      
      @yesterday_fund = Fund.yesterday_fund(get_current_store)
      @fund = Fund.todays_fund(get_current_store)                        
      

    respond_to do |format|
      if @expense.save
        flash[:notice] = 'Gasto registrado.'
        format.js  {
                      render :update do |page|  

                        RAILS_DEFAULT_LOGGER.error("\n Se graba  \n")                 
                            
                        @expenses = Expense.find(:all, :order=>"expense_date ASC", :conditions=>"store_id = #{@expense.store_id} and expense_date >= '#{Time.zone.now}' and expense_date < '#{Time.zone.now+1.day}'")
                        @total_expenses = 0
                        RAILS_DEFAULT_LOGGER.error("\n Se graba  \n")                 
                        @expenses.each do |e| @total_expenses += e.amount unless e.amount.nil? end
                        RAILS_DEFAULT_LOGGER.error("\n Se graba  \n")                                           
                        page.replace 'detalle', :partial => 'expenses_list'
                        page.replace 'results', :partial => 'summary'                        
                        page.visual_effect :highlight, 'expenses_table'            
                        page.visual_effect :fade, 'product_error'
                        page.call('clean_forms')            
                        page.replace_html 'product_error', ""
                      end
                   }
      else
        
        format.js  {
                      render :update do |page|
                        RAILS_DEFAULT_LOGGER.error("\n #{ @expense.errors }  \n")                 
                        
                      end
                   }
        
        format.xml  { 
              page.replace_html 'product_error', "Error en la operación"
                    }
      end
    end    
  end
  
  
  def update
    
    
  end
  
  
  def destroy
     @expense = Expense.find(params[:id])
     @expense.destroy
     @time_from = @time_to = Date.new(Time.zone.now.year,Time.zone.now.month,Time.zone.now.day)    

       if admin? 

          admin_expenses

        else

          salesman_expenses

        end

             @expenses = Expense.find(:all, :order=>"expense_date ASC", :conditions=>"store_id = #{@expense.store_id} and expense_date >= '#{Time.zone.now}' and expense_date < '#{Time.zone.now+1.day}'")
              @total_expenses = 0

              @expenses.each do |e| @total_expenses += e.amount unless e.amount.nil? end
     
                @yesterday_fund = Fund.yesterday_fund(get_current_store)
                @fund = Fund.todays_fund(get_current_store)                        
     
     

      respond_to do |format|
        format.js  { 
                              render :update do |page|
                                page.replace 'detalle', :partial => 'expenses_list'
                                page.replace 'results', :partial => 'summary'                        
                                page.visual_effect :highlight, 'expenses_table'            
                                page.visual_effect :fade, 'product_error'
                              end
          
          }
      end

  end

  

end
