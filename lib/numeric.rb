class Numeric 

  def to_letters

    letras = ""
    # Separo los decimales de los enteros    
    str_split = self.to_s.split(".")          
    entero = str_split[0]
    decimal =  str_split[1]

    if entero.length == 5
      entero.insert(0,"0") 
    end
    if entero.length == 4
      entero.insert(0,"00") 
    end
    if entero.length == 3
      entero.insert(0,"000") 
    end
    if entero.length == 2
      entero.insert(0,"0000") 
    end
    if entero.length == 1
      entero.insert(0,"00000") 
    end

    cnumero1 = entero.slice(0..2)
    if cnumero1 != "000"
      letras += numero_999(cnumero1) + " mil "
    end

    cnumero2 = entero.slice(3..5)

    if cnumero2 != "000"
      letras += numero_999(cnumero2)
    end
    if decimal.length == 1
      decimal = decimal + "0"
    end
    return  "son #{letras} Nuevos Soles con #{(!decimal.nil? || decimal == "0") ? "#{decimal}/100" : "00/100"}".upcase

  end


  def numero_999(numero)

    letras = ""
    #Voy separando los valores de las partes del numero (unidad, decena y centena)

    centena = numero.slice(0..0)
    decena = numero.slice(1..1)                 
    unidad = numero.slice(2..2)                 

    if centena == "1" and decena == '0' and unidad == "0"
      letras = 'cien '
      return letras
    end

    #Analizo la centena
    if centena == "1" : letras = 'ciento ' end
      if centena == "2" : letras = 'doscientos ' end
        if centena == "3" : letras = 'trescientos ' end
          if centena == "4" : letras = 'cuatrocientos ' end
            if centena == "5" : letras = 'quinientos ' end
              if centena == "6" : letras = 'seiscientos ' end
                if centena == "7" : letras = 'setecientos ' end
                  if centena == "8" : letras = 'ochocientos ' end
                    if centena == "9" : letras = 'novecientos ' end


                      #Analizo la decena
                      if decena == "1" and unidad == '0' 
                        letras += 'diez' 
                        return letras
                      end
                      if decena == "1" and unidad == '1' 
                        letras += 'once' 
                        return letras
                      end
                      if decena == "1" and unidad == '2' 
                        letras += 'doce' 
                        return letras
                      end
                      if decena == "1" and unidad == '3' 
                        letras += 'trece' 
                        return letras 
                      end
                      if decena == "1" and unidad == '4' 
                        letras += 'catorce' 
                        return letras 
                      end
                      if decena == "1" and unidad == '5' 
                        letras += 'quince' 
                        return letras 
                      end

                      if decena == '2' and unidad == '0' 
                        letras += 'veinte '
                        return letras 
                      end
=begin
                      if decena == "1" : letras += 'dieci' end
                        if decena == "2" : letras += 'veinti' end
                          if decena == "3" : letras += 'treinta ' end
                            if decena == "4" : letras += 'cuarenta ' end
                              if decena == "5" : letras += 'cincuenta ' end
                                if decena == "6" : letras += 'sesenta ' end
                                  if decena == "7" : letras += 'setenta ' end
                                    if decena == "8" : letras += 'ochenta ' end
                                      if decena == "9" : letras += 'noventa ' end
=end

                      if decena == "1" : letras += 'diez y ' end
                        if decena == "2" : letras += 'veinte y ' end
                          if decena == "3" : letras += 'treinta y ' end
                            if decena == "4" : letras += 'cuarenta y ' end
                              if decena == "5" : letras += 'cincuenta y ' end
                                if decena == "6" : letras += 'sesenta y ' end
                                  if decena == "7" : letras += 'setenta y ' end
                                    if decena == "8" : letras += 'ochenta y ' end
                                      if decena == "9" : letras += 'noventa y ' end

                                        #Para ver si 
                                        a = ['3','4','5','6','7','8','9']
                                        if a.include?(decena) and unidad != "0" : letras += '' end

                                          #Analizo la unidad
                                          if unidad == "1" : letras += ' un' end
                                            if unidad == "2" : letras += ' dos' end
                                              if unidad == "3" : letras += ' tres' end
                                                if unidad == "4" : letras += ' cuatro' end
                                                  if unidad == "5" : letras += ' cinco' end
                                                    if unidad == "6" : letras += ' seis' end
                                                      if unidad == "7" : letras += ' siete' end
                                                        if unidad == "8" : letras += ' ocho' end    
                                                          if unidad == "9" : letras += ' nueve' end

                                                            return letras

                                                          end
                                                          def centavos(numero)
                                                            letras = ""
                                                            decena = numero.slice(0..0)                 
                                                            unidad = numero.slice(1..1)                 
                                                            #Analizo la decena
                                                            if decena == "1" and unidad == '0' 
                                                              letras += 'diez' 
                                                              return letras
                                                            end
                                                            if decena == "1" and unidad == '1' 
                                                              letras += 'once' 
                                                              return letras
                                                            end
                                                            if decena == "1" and unidad == '2' 
                                                              letras += 'doce' 
                                                              return letras
                                                            end
                                                            if decena == "1" and unidad == '3' 
                                                              letras += 'trece' 
                                                              return letras 
                                                            end
                                                            if decena == "1" and unidad == '4' 
                                                              letras += 'catorce' 
                                                              return letras 
                                                            end
                                                            if decena == "1" and unidad == '5' 
                                                              letras += 'quince' 
                                                              return letras 
                                                            end

                                                            if decena == '2' and unidad == '0' 
                                                              letras += 'veinte '
                                                              return letras 
                                                            end

                                                            if decena == "1" : letras += 'dieci' end
                                                              if decena == "2" : letras += 'veinti' end
                                                                if decena == "3" : letras += 'treinta ' end
                                                                  if decena == "4" : letras += 'cuarenta ' end
                                                                    if decena == "5" : letras += 'cincuenta ' end
                                                                      if decena == "6" : letras += 'sesenta ' end
                                                                        if decena == "7" : letras += 'setenta ' end
                                                                          if decena == "8" : letras += 'ochenta ' end
                                                                            if decena == "9" : letras += 'noventa ' end

                                                                              #Para el Y
                                                                              a = ['3','4','5','6','7','8','9']
                                                                              if a.include?(decena) and unidad != "0" : letras += ' ' end

                                                                                #Analizo la unidad
                                                                                if unidad == "1" : letras += 'un' end
                                                                                  if unidad == "2" : letras += 'dos' end
                                                                                    if unidad == "3" : letras += 'tres' end
                                                                                      if unidad == "4" : letras += 'cuatro' end
                                                                                        if unidad == "5" : letras += 'cinco' end
                                                                                          if unidad == "6" : letras += 'seis' end
                                                                                            if unidad == "7" : letras += 'siete' end
                                                                                              if unidad == "8" : letras += 'ocho' end
                                                                                                if unidad == "9" : letras += 'nueve' end

                                                                                                  return letras
                                                                                                end

                                                                                              end