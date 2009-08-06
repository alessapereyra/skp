
set :cron_log, "#{RAILS_ROOT}/log/cron_log.log"

every 2.hour do
  rake "thinking_sphinx:index"
end

every :reboot do 
  rake "thinking_sphinx:start"
end

every 1.days, :at => "12am" do
  runner "Fund.close_cashier"
end

