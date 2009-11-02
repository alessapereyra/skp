class ProvidersController < ApplicationController

  before_filter [:has_privileges?,:no_cache]
  
  def index 
    @providers = Provider.find(:all)
  end
  
  def new
    @provider = Provider.new
  end
  
  def create 
    @provider = Provider.new(params[:provider])

    respond_to do |format|
       if @provider.save
         flash[:notice] = 'Proveedor ingresado al cat&aacute;logo'
         format.html { redirect_to providers_path }
         format.xml  { render :xml => @provider, :status => :created, :location => @provider }
       else
         format.html { redirect_to new_provider_path }
         format.xml  { render :xml => @provider.errors, :status => :unprocessable_entity }
       end
    end   
       
  end
  
  def edit
    
    @provider = Provider.find(params[:id])
    
  end
  
  # PUT /providers/1
  # PUT /providers/1.xml
  def update
    @provider = Provider.find(params[:id])

    respond_to do |format|
      if @provider.update_attributes(params[:provider])
        flash[:notice] = 'Datos de proveedor actualizados'
        format.html { redirect_to providers_path }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @provider.errors, :status => :unprocessable_entity }
      end
    end
  end

end
