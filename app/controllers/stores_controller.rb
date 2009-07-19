class StoresController < ApplicationController

  before_filter :has_privileges?
  
def index
  @stores = Store.find(:all)
end

def new
  @store = Store.new
end

def create 
  @store = Store.new(params[:store])

  respond_to do |format|
     if @store.save
       flash[:notice] = 'Tienda/Almacen ingresado al cat&aacute;logo'
       format.html { redirect_to stores_path }
       format.xml  { render :xml => @store, :status => :created, :location => @store }
     else
       format.html { redirect_to new_store_path }
       format.xml  { render :xml => @store.errors, :status => :unprocessable_entity }
     end
  end   
     
end


def edit
  @store = Store.find(params[:id])
end

# PUT /stores/1
# PUT /stores/1.xml
def update
  @store = Store.find(params[:id])

  respond_to do |format|
    if @store.update_attributes(params[:store])
      flash[:notice] = 'Tienda correctamente actualizada.'
      format.html { redirect_to(@store) }
      format.xml  { head :ok }
    else
      format.html { render :action => "edit" }
      format.xml  { render :xml => @store.errors, :status => :unprocessable_entity }
    end
  end
end

end
