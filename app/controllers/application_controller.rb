# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time


include HoptoadNotifier::Catcher
include ExceptionNotifiable

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery
  
  before_filter :is_authenticated
  #before_filter :log_ram # or use after_filter


  def no_cache
    headers["Cache-Control"] = "no-cache,no-store,max-age=0,must-revalidate, post-check=0, pre-check=0"
    headers["Pragma"] = "no-cache"
    headers["Expires"] = "-1"
        
  end
  
  
  def log_ram
  #  mem_usage = `pmap #{Process.pid} | tail -1`
  #  logger.warn 'RAM USAGE: ' + (unless mem_usage.blank? then mem_usage[9,40].strip else "" end  )
  end

  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  
  def current_input_order
  
    if not session[:input_order_id] or not InputOrder.exists?(session[:input_order_id])
      
      @input_order = InputOrder.new      
      provider_id = 1
      store_id = get_current_store
      owner_id = get_current_store
      
      unless params[:input_order].nil?
        provider_id = params[:input_order][:provider_id]
        store_id = params[:input_order][:store_id]
        owner_id = params[:input_order][:owner_id]
      end
        
      @input_order.provider_id = provider_id || 1
      @input_order.store_id = store_id || 1
      @input_order.owner_id = owner_id || 1
      @input_order.order_date = Time.zone.now
      @input_order.cost = 0
      @input_order.status = "pendiente"
      @input_order.unload_stock = true
      @input_order.save!
      session[:input_order_id] = @input_order.id
    
    
    
      
    end
    
    return session[:input_order_id]
    
  end
  
  def is_authenticated
    unless session[:logged_user] 

      session[:last_url] = request.request_uri
      redirect_to login_path
      
    end
  end
  
  def has_privileges?
    unless (User.find_by_username(session[:logged_user]).admin? || User.find_by_username(session[:logged_user]).store_admin? || User.find_by_username(session[:logged_user]).store_supervisor? )
      redirect_to no_access_path
    end
  end
  
  
  def admin?
    User.find_by_username(session[:logged_user]).admin?
  end
  
  
  def store_supervisor?
    User.find_by_username(session[:logged_user]).store_supervisor?
  end
  
  
  def store_admin?
    User.find_by_username(session[:logged_user]).store_admin?
  end
  
  
  def change_store
    
    set_current_store(params[:options_current_store]) unless params[:options_current_store].nil?
    redirect_to :back
    
  end
  
  def get_current_store
    session[:current_store_id] ||= User.find_by_username(session[:logged_user]).store_id
    #User.find_by_username(session[:logged_user]).store_id
    
  end
  
  def get_search_message

    if [""," "].include? session[:product_search]
      
      message = "nuestros productos"
      
    else

    message = "#{session[:product_search]} "

    end
    
    unless ["", " "].include? session[:product_add]
      message = " '#{session[:product_search]} #{session[:product_add]}'"
    end
    
    if (session[:product_from] and session[:product_to]) and (session[:product_from].to_i != 0 and session[:product_to].to_i !=20)
      message << " para #{session[:product_from]} a #{session[:product_to]} años"
    end
    
    if session[:price_from] and session[:price_to] and (session[:price_from].to_i != 0 and session[:price_to].to_i != 1000)
      message << " de #{session[:price_from]} a #{session[:price_to]} soles"
    end
        

      
    message
    
  end
  
  def set_current_store(store_id)
    user = User.find_by_username(session[:logged_user])
    user.store_id = store_id unless user.nil?
    user.save unless user.nil?
    session[:current_store_id] = user.store_id unless user.nil?
  end

  def clean(value)
    
    #Iconv.conv("ISO-8859-1//ignore","UTF-8", value.to_s.gsub!("ñ","n"))
    value
  end

  
end
