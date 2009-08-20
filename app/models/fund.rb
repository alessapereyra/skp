# == Schema Information
#
# Table name: funds
#
#  id             :integer(4)      not null, primary key
#  store_id       :integer(4)
#  registry_date  :datetime
#  net_income     :decimal(10, 2)
#  decimal        :decimal(10, 2)
#  widthdrawal    :decimal(10, 2)
#  cash_amount    :decimal(10, 2)
#  created_at     :datetime
#  updated_at     :datetime
#  expenses       :decimal(10, 2)
#  earnings       :decimal(10, 2)
#  yesterday_fund :integer(4)
#

class Fund < ActiveRecord::Base

  validates_presence_of :net_income
  validates_presence_of :store_id
  
  has_one :yesterday, :class_name => "Fund", :foreign_key => "yesterday_fund"

  belongs_to :store

  def self.set_last_fund
    
    days = 30
    
    30.times do 

      tiendas_ids = [1,2,3,5]

      tiendas_ids.each do |tienda_id|      

        todays_fund = Fund.find(:all, :order=>"registry_date DESC" ,:conditions=>["store_id in (?) and registry_date between CURDATE() and DATE_ADD(CURDATE(), INTERVAL +1 DAY)",store]).first

        

      end # each
      
    end #times
    
  end

  def self.close_cashier
    
    #Obtenemos los fondos del día de ayer
    #Se obtienen los montos iniciales, y lo que se descarga,
    #se graba lo que resta
    #y finalmente lo que se resta se registra como inicial de este dia
    #para cada una de las tiendas
    
    tiendas_ids = [1,2,3,5]
    tiendas_ids.each do |tienda_id|

      @yesterday = Fund.yesterday_fund(tienda_id)
      
      
      
      if @yesterday_fund.nil?

        yesterday_fund = Fund.new
        yesterday_fund.registry_date = Time.zone.now - 1.day
        yesterday_fund.net_income = 0.0
        yesterday_fund.widthdrawal = 0.0
        yesterday_fund.cash_amount = 0.0
        yesterday_fund.store_id = tienda_id
        yesterday_fund.save!
        @yesterday_fund = yesterday_fund
        
      end

      
      
      
      
      @yesterday.cash_amount = @yesterday.net_income + @yesterday.earnings
                               - @yesterday.expenses - @yesterday.widthdrawal
      @yesterday.save
      
      @today = Fund.todays_fund(tienda_id)

      if @today.nil?
        todays_fund = Fund.new
        todays_fund.registry_date = Time.zone.now
        todays_fund.net_income = 0.0
        todays_fund.widthdrawal = 0.0
        todays_fund.cash_amount = 0.0
        todays_fund.store_id = tienda_id
        todays_fund.save!
        @today = todays_fund
      end
            
      @today.net_income = @yesterday.cash_amount
      @today.yesterday = @yesterday
      @today.save
      
    end
    
    
  end

  def record_expense(expense)
    self.expenses -= expense unless expense.blank?
    self.save
  end
  
  def record_earnings(earnings)
    self.earnings += earnings unless earnings.blank?
    self.save
  end

  def update_fund(earnings,expenses)
    self.earnings = earnings
    self.expenses = expenses
    self.cash_amount = self.net_income + self.earnings - self.expenses - self.widthdrawal
    self.save
  end

  def self.yesterday_fund(store)
       
   yesterday_fund = Fund.find(:all, :order=>"registry_date DESC",:conditions=>["store_id in (?) and registry_date between DATE_ADD(CURDATE(), INTERVAL -1 DAY) and CURDATE()", store]).last
    
  end
  
  def self.todays_fund(store)
    todays_fund = Fund.find(:all, :order=>"registry_date DESC" ,:conditions=>["store_id in (?) and registry_date between CURDATE() and DATE_ADD(CURDATE(), INTERVAL +1 DAY)",store]).first
    
  end


end
