begin

  pdf.canvas do
  
    pdf.bounding_box([50,750], :width => 150, :height=>80) do
    
	    pdf.image("#{RAILS_ROOT}/public/images/web/logo-pdf.jpg",:width=>150)

    end

      pdf.bounding_box([280,730], :width => 150, :height=>80) do

  	    pdf.text "Cotización",:size => 20

      end


    pdf.bounding_box([30,480], :width=>600,:height=>400) do
    pdf.text "Productos cotizados", :at=>[40,410]
    pdf.table(@table_values,
             :font_size => 12,
            :horizontal_padding => 5,
           :vertical_padding => 3,
          :border_width => 1,
         :position => :center,
        :row_colors => ['ffffff','e3f7fa'],
       :headers => @table_headers)
     end

  
  end



rescue Exception => ex

          RAILS_DEFAULT_LOGGER.error("\n #{ex}  \n")    
          RAILS_DEFAULT_LOGGER.error("\n #{@row_values}  \n")          
          RAILS_DEFAULT_LOGGER.error("\n #{@table_values}  \n")                      

end