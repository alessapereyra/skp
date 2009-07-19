# == Schema Information
# Schema version: 20090226210822
#
# Table name: funds
#
#  id            :integer(4)      not null, primary key
#  store_id      :integer(4)
#  registry_date :datetime
#  net_income    :decimal(10, 2)
#  decimal       :decimal(10, 2)
#  widthdrawal   :decimal(10, 2)
#  cash_amount   :decimal(10, 2)
#  created_at    :datetime
#  updated_at    :datetime
#

class Fund < ActiveRecord::Base

  validates_presence_of :net_income
  validates_presence_of :store_id
  

  belongs_to :store

  def self.yesterday_fund(store)
    
    
   yesterday_fund = Fund.find(:all, :order=>"registry_date DESC",:conditions=>["store_id in (?) and registry_date between DATE_ADD(CURDATE(), INTERVAL -1 DAY) and CURDATE()", store]).last
 
 

   if yesterday_fund.nil?

     date_back = Time.zone.now - 1.day

    # SI ESTAMOS LUNES, Y AYER NO HUBO MOVIMIENTO DE CAJA, REGRESAMOS A LOS DATOS DEL SÁBADO
     if Time.zone.now.wday == 1

       date_back -= 1.day
       
       yesterday_fund = Fund.find(:all, :order=>"registry_date DESC",:conditions=>["store_id in (?) and registry_date between DATE_ADD(CURDATE(), INTERVAL -2 DAY) and DATE_ADD(CURDATE(), INTERVAL -1 DAY)", store]).last

       return yesterday_fund unless yesterday_fund.blank?              
       
     end

     yesterday_fund = Fund.new
     yesterday_fund.registry_date = date_back
     yesterday_fund.net_income = 0.0
     yesterday_fund.widthdrawal = 0.0
     yesterday_fund.cash_amount = 0.0
     yesterday_fund.store_id = store
     yesterday_fund.save!
   
     
   end

   yesterday_fund
   
  end
  
  def self.todays_fund(store)
    todays_fund = Fund.find(:all, :order=>"registry_date DESC" ,:conditions=>["store_id in (?) and registry_date between CURDATE() and DATE_ADD(CURDATE(), INTERVAL +1 DAY)",store]).first

    if todays_fund.nil?
      todays_fund = Fund.new
      todays_fund.registry_date = Time.zone.now
      todays_fund.net_income = 0.0
      todays_fund.widthdrawal = 0.0
      todays_fund.cash_amount = 0.0
      todays_fund.store_id = store
      todays_fund.save!
    end
    
    todays_fund
    
  end


end
