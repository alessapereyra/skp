module SendingGuidesHelper
  
  def print_sending_type
    case @sending_guide.sending_type
      when "" then "Envío de Productos a Clientes"
      when "perdida" then "Retiro por p&eacute;rdida"
      when "mal-estado" then "Retiro por Mal Estado"
      when "consumo-interno" then "Retiro por Consumo Interno"
      when "consumo-externo" then "Retiro por Consumo Externo"
      when "devolucion" then "Retiro por Devoluci&oacute;n a Proveedor"        
    end
  end
  
end
