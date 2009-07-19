module ExpensesHelper
  
  def yesterdays_fund
    Fund.yesterday_fund(current_store).cash_amount
  end
  
  def todays_fund
    Fund.todays_fund(current_store).cash_amount
  end
  
end
