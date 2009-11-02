class ExpensesController < ApplicationController

  before_filter [:has_privileges?,:no_cache]


  def get_orders

    @mastercard_orders = @visa_orders = []        
    selected_store= String.new
    if get_current_store == 4 
      selected_store = ""
    else
      selected_store = "and store_id=#{get_current_store}"
    end

    condiciones = " and type not like 'nota_de_credito' and status LIKE 'accepted'" 
    condiciones << " and order_date >= '#{@time_from}' "
    condiciones << " and order_date < '#{@time_to+1.day}' #{selected_store} "

    @orders = Order.find(:all, 
                         :conditions=>"credit_card like 'Efectivo' #{condiciones}",
                         :order=>"number DESC")    

    @visa_orders = Order.find(:all, 
                              :conditions=>"credit_card like 'VISA' #{condiciones}",
                              :order=>"number DESC")    
                              
    @mastercard_orders = Order.find(:all, 
                                    :conditions=>"credit_card like 'Mastercard' #{condiciones}",
                                    :order=>"number DESC")    
                                    

    @visa_total = @mastercard_total = 0.0
    @mastercard_total = @mastercard_orders.sum{|o| o.price }   
    @visa_total = @visa_orders.sum{|o| o.price }
                                    
    @totals = @orders.sum {|order| order.price } || 0.0
    
    return @totals

    
  end

  def admin_expenses

    # SOLO EFECTIVO

    if get_current_store == 4
      
      @orders = Order.find(:all, :order=>"number DESC", :conditions=>"credit_card like 'Efectivo' and type not like 'nota_de_credito' and status LIKE 'accepted' and order_date >= '#{@time_from}' and order_date < '#{@time_to+1.day}' ")    
      @visa_orders = Order.find(:all, :order=>"number DESC", :conditions=>"credit_card like 'VISA' and type not like 'nota_de_credito' and status LIKE 'accepted' and order_date >= '#{@time_from}' and order_date < '#{@time_to+1.day}' ")    
      @mastercard_orders = Order.find(:all, :order=>"number DESC", :conditions=>"credit_card like 'Mastercard' and type not like 'nota_de_credito' and status LIKE 'accepted' and order_date >= '#{@time_from}' and order_date < '#{@time_to+1.day}' ")    

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

    # @yesterday_fund = Fund.yesterday_fund(get_current_store)    
    # 
    @fund = Fund.todays_fund(get_current_store)
    @fund.update_fund(@totals,@total_expenses)  
    
  end

  def index
    
      # SOLO TE TOMAN EN CUENTA ORDENES EN EFECTIVO
      # SE COGE EL SALDO DEL DIA ANTERIOR, Y SE RESTA DEL DE HOY
      # NO SE INCLUYEN NOTAS DE CREDITO
      
      @expense = Expense.new
      
      @time_from = @time_to = Date.new(Time.zone.now.year,Time.zone.now.month,Time.zone.now.day)
      
      get_orders

      @total_expenses = 0.0      
      @expenses = Expense.find(:all, :order=>"expense_date DESC", :conditions=>"store_id = #{get_current_store} and expense_date >= '#{Time.zone.now}' and expense_date < '#{Time.zone.now+1.day}'")
      @expenses.each do |e| @total_expenses += e.amount unless e.amount.nil? end
            
      setup_fund
      
    
  end
  
  def create

    @time_from = @time_to = Date.new(Time.zone.now.year,Time.zone.now.month,Time.zone.now.day)    
    @expense = Expense.create(params[:expense])
    @expense.expense_date = Time.zone.now
    @expense.store_id = get_current_store
    get_orders
    
    @fund = Fund.todays_fund(get_current_store)                        
      

    respond_to do |format|
      if @expense.save
        flash[:notice] = 'Gasto registrado.'
        @fund.record_expense(@expense.amount)
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
                        page.replace_html 'product_error', "Error en la operación"                        
                      end
                   }
        
        format.xml  { 

                    }
      end
    end    
  end
  
  
  def update
    
    
  end
  
  
  def destroy
     @expense = Expense.find(params[:id])
     Fund.todays_fund(get_current_store).record_expense(-@expense.amount)
     @expense.destroy
     @time_from = @time_to = Date.new(Time.zone.now.year,Time.zone.now.month,Time.zone.now.day)    

     get_orders
     
     @expenses = Expense.find(:all, :order=>"expense_date ASC", :conditions=>"store_id = #{@expense.store_id} and expense_date >= '#{Time.zone.now}' and expense_date < '#{Time.zone.now+1.day}'")
     
      @total_expenses = 0

      @expenses.each do |e| @total_expenses += e.amount unless e.amount.nil? end

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
