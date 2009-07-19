class QuoteExcelController < ApplicationController

  require 'rubygems'
  #require "roo"
  require 'spreadsheet/excel'
  
  

  # include Spreadsheet
  
  skip_before_filter :is_authenticated, :only=>[:pdf,:xls]

  def pdf

    #Nuevo archivo XLS en el disco:   
    @quote = Quote.find(params[:id])
    filename = "cotizacion-" + clean(@quote.id.to_s) + "-" +Time.zone.now.strftime("%Y%m%d") + ".pdf"        
    
    prawnto :prawn => {
      
      :left_margin=>0,
                  :right_margin=>0,
                  :top_margin=>10,
                  :bottom_margin=>10
    }, :inline=>false,
              :filename => filename
    
    @table_headers = ['item','edad','sexo','codigo','descripcion','precio sin igv','precio','cantidad','subtotal']

    @row_values = []
    item = 1
    @quote.quote_details.each do |quote_detail|
      
      @row_values << ["#{item.to_s}", "#{quote_detail.age_from}-#{quote_detail.age_to}", 
                      "#{quote_detail.product.sex}", "#{quote_detail.product.code}", 
                      "#{quote_detail.product.name.humanize}","#{(quote_detail.price/1.19).to_f.to_s}" ,"#{quote_detail.price.to_s}", 
                      "#{quote_detail.quantity.to_s}", "#{quote_detail.subtotal.to_s}"]
      item += 1
    end

    @table_values = @row_values

  end

  def xls
    
    
    begin

    #Nuevo archivo XLS en el disco:   
    @quote = Quote.find(params[:id])

    #Nombre del archivo
    client =  @quote.client.nil? ?  "web" : clean(@quote.client.name)
    
    filename = "#{RAILS_ROOT}/public/xls/cotizacion-skykids-" + client + "-" +Time.zone.now.strftime("%Y%m%d") + ".xls"

    #Creamos el documento y el libro respectivo
    document = Spreadsheet::Excel.new(filename)

    quote_book = document.add_worksheet(clean("Cotizacion"))


    #Establecemos las cabeceras de la tablas. 
    # Codigo  Nombre   Instrumento_N  Instrumento_N
    #   1     Alvaro        16            15 

    #Grabamo el Código y Nombre del Curso

=begin

    format1 = Spreadsheet::Excel::Format.new(
    :color => "green",
    :bold => true,
    :border => 2,
    :underline => true
    )

    
    format = Spreadsheet::Excel::Format.new
    format.border = true
    format.border_color = 'black'
=end


    quote_book.write(5,3,clean("Cotizacion de Skykids Peru S.A.C."))
    
    quote_book.write(8,2,clean("Empresa:"))
    quote_book.write(8,3,(@quote.client.name))  unless @quote.client.blank?
    quote_book.write(9,2,clean("RUC:"))
    quote_book.write(9,3,clean((@quote.client.ruc)))  unless @quote.client.blank?
    
    quote_book.write(10,2,clean("Telefono:"))
    quote_book.write(10,3,clean((@quote.client.telephone))) unless @quote.client.blank?
    quote_book.write(11,2,clean("Contacto:"))
    quote_book.write(11,3,clean(@quote.contact_name))
    # quote_book.write(12,3,clean(@quote.sending_details.to_s.gsub!("\n",""))) unless @quote.sending_details.blank?
    

    columna = 1
    #Grabamos los nombres de la cabecera en el Excel
    @header = %w(Item Edad Sexo Codigo Descripcion Sin.IGV. Precio Cant Subtotal)    
    @header.each do |cab|
      quote_book.write(18,columna,clean(cab))
      columna += 1
    end   

    
    #Empezamos en la 5ta fila
    row = 19

    item = 1
    
    @final_quote_details = QuoteDetail.find(:all, :conditions=>["quote_id = ? and (additional is false or additional 
       is null)",@quote.id],:order => "age_from ASC, age_to ASC, sex DESC")
    @alternative_quote_details = QuoteDetail.find_all_by_quote_id_and_additional(@quote.id,true, :order => "age_from 
       ASC, age_to ASC, sex DESC")
    
      
      # Una fila para cada empresa
      @final_quote_details.each do|q|
        # Añado la fila con los datos en sus respectivas columnas
        unless q.product.blank?
          quote_book.write(row,1,item)      
          quote_book.write(row,2,"#{q.age_from}-#{q.age_to}")                  
          quote_book.write(row,3,clean(q.sex))               
          quote_book.write(row,4,clean(q.product.code))         
          quote_book.write(row,5,clean(q.product.name))
          quote_book.write(row,6,clean((q.price/1.19).round(2).to_s))   
          quote_book.write(row,7,clean(q.price.to_f.round(2).to_s))                                      
          quote_book.write(row,8,clean(q.quantity).to_s)
          quote_book.write(row,9,clean(q.subtotal.to_f.round(2).to_s))                                    
        end
        row += 1
        item += 1
      end
      
      row +=2
      quote_book.write(row,2,clean("Alternativas")) unless @alternative_quote_details.empty?
      row +=2
      item = 1
      
        @alternative_quote_details.each do|q|
          unless q.product.blank?
            # Añado la fila con los datos en sus respectivas columnas
            quote_book.write(row,1,item)      
            quote_book.write(row,2,"#{q.age_from}-#{q.age_to}")      
            quote_book.write(row,3,clean(q.sex))      
            quote_book.write(row,4,clean(q.product.code))
            quote_book.write(row,5,clean(q.product.name))
            quote_book.write(row,6,clean((q.price/1.19).to_f.round(2)))   
            quote_book.write(row,7,clean(q.price.to_f.round(2)))                              
            quote_book.write(row,8,clean(q.quantity))
            quote_book.write(row,9,clean(q.subtotal.to_f.round(2)))                                    
          end
          row += 1
          item += 1
        end

      row += 1
      quote_book.write(row,8,"Total")
      quote_book.write(row,9,@quote.price.to_f.round(2)) unless @quote.price.nil?                                    
    
      row +=1 
      quote_book.write(row,1,"LOS PRECIOS INCLUYEN EL IGV")
=begin
=end 
    # Cerramos el libro
    document.close

    # Enviamos el fichero al navegador
    send_file filename
    
    
    rescue Iconv::IllegalSequence => e 
      
      RAILS_DEFAULT_LOGGER.error("\n #{e} \n")                 
      render :layout => false  
        
    end

  end



  def upload 

    @quote = TeacherCourse.find(params[:quote_id])

    #Nuevo archivo XLS en el disco:   
    filename = "#{RAILS_ROOT}/public/xls/uploaded/" + clean(@quote.course.name) + Time.now.strftime("%Y%m%d%H%M%S") + ".xls"

    #Grabamos el archivo que ha sido subido
    File.open(filename, "wb") do |f| 
      f.write(params['xls'].read)
    end

    #Cargamos el archivo XLS
    xls_file = Excel.new(filename)
    xls_file.default_sheet = xls_file.sheets.first

    #Obtenemos el código de CursoDictado
    course_id = xls_file.cell(2,'B')
    teacher_id = xls_file.cell(3,'B')
    quote = TeacherCourse.find_by_course_id_and_teacher_id(course_id,teacher_id)

    #Por cada alumno, realizar el registro
    6.upto(xls_file.last_row) do | line |

      #Obtenemos el curso que lleva el alumno
      student_id = xls_file.cell(line,'A')
      sc = StudentCourse.find_by_student_id_and_course_id(student_id,course_id)

      3.upto(xls_file.last_column) do | column |
        criteria = Criteria.find_by_name(xls_file.cell(5,column))
        qualification = xls_file.cell(line,column)

        sc.update_grade(quote.id,criteria.id,qualification)
      end    

    end


    flash[:notice]="Archivo subido exitosamente"




    redirect_to quote_path
  end




end
