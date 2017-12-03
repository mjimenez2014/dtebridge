# encoding: ISO-8859-1
class Api::V1::DoccompraController < Api::V1::ApiController
  def procesarecibo
    demails = Docsemail.where(estado: "RECIBIDO").all
    #Recorro los correos descargados del modelo Docsemail
    demails.each do |demail| 
      #begin
        @doc_xml = 'PROCESADO' 
        #Mientras el correo no es nulo 
        unless demail.nil?
          #Convierto el xml en un hash
          json= Hash.from_xml(demail.xmlrecibido.force_encoding("ISO-8859-1").encode("utf-8", replace: nil))
          puts "=================== XML RECIBIDO ================================"
          puts demail.xmlrecibido

            if json['EnvioDTE']['SetDTE']['DTE'].kind_of?(Array) # si es un arreglo
               json['EnvioDTE']['SetDTE']['DTE'].each do  |dte| 
                procesadoc(dte,demail)
               end
            else
              procesadoc(json['EnvioDTE']['SetDTE']['DTE'],demail)
            end
          @doc_xml = "OK"

        end
      #rescue
        #puts "====== ERROR EN PROCESAR RECIBO ======"
        #puts demail.id
        demail.estado = 'ACUSEPROVEEDOR'
        demail.save
      #end  
    end  
    render 'api/v1/doccompra/procesarecibo'
  end
  # Esta funcion toma el hash para crear el modelo Doccompra
  # tambien carga el correo para guardar el xml en Doccompra
  def procesadoc(dte, docEmail)
    #begin
        doc = dte['Documento']
        doc['TED'].delete('version')
        idDoc = doc['Encabezado']['IdDoc']



        emisor = doc['Encabezado']['Emisor']
        receptor = doc['Encabezado']['Receptor']
        totales = doc['Encabezado']['Totales']
        _detalles = doc['Detalle']     
        referencia = doc['Referencia']
        comisiones = doc['Comisiones']
        dsc_rcg_global = doc['DscRcgGlobal']
        puts "============ dsc_rcg_global =================="
        puts dsc_rcg_global
        impuesto_reten = totales['ImptoReten']
        montos_pago = doc['Encabezado']['IdDoc']['MntPagos']
        idDoc.delete("MntPagos")
        totales.delete("ImptoReten")
        documento = idDoc.merge(emisor).merge(receptor).merge(totales)

       
        detalles = Array.new
        cdgI = Hash.new
        #subD = Hash.new



        if _detalles.kind_of?(Array)
          _detalles.each do |det|


            if det["CdgItem"].kind_of?(Array)
              cdgI = det["CdgItem"].first
            else
              cdgI = det["CdgItem"]
            end
            # TO DO Falta configurar los nested para estos modelos   
            det.delete("Subcantidad")
            det.delete("CdgItem")
            det.delete("IndExe")
          
            subD = det["SubDscto"]
            if subD.nil?
              subD={}
            else    
              det.delete("SubDscto")
              detalles << subD
            end  
            if cdgI.present?
              detalles << det.merge(cdgI)
            else
              detalles << det  
            end            
          end    
        else
          det = _detalles
          if det["CdgItem"].kind_of?(Array)
            cdgI = det["CdgItem"].first
          else
            cdgI = det["CdgItem"]
          end   
          det.delete("CdgItem")
          
            subD = det["subdsctos_attributes"]
            if subD.nil?
              subD={}
            else
              det.delete("subdsctos_attributes")
              detalles << subD
            end   
            if cdgI.present?
              detalles << det.merge(cdgI)
            else
              detalles << det  
            end
        end


        if referencia.nil? 
          r = [{}] 
        else
          if referencia.kind_of?(Array)
            r = referencia
          else  
            r = [referencia]
          end   
        end

        #if comisiones.nil? x
          comisiones = [{}] 
        #end
        if dsc_rcg_global.nil? 
          dsc_rcg_global = [{}] 
        end


        if impuesto_reten.nil? 
          ir = [{}] 
        else
          if impuesto_reten.kind_of?(Array)
            ir = impuesto_reten
          else  
            ir = [impuesto_reten]
          end     
        end
        if montos_pago.nil? 
          montos_pago = [{}] 
        end

        documento[:detcompras_attributes] = detalles
        documento[:refdetcompras_attributes] = r
        documento[:comisioncompras_attributes] = comisiones
        documento[:dscrcgglobalcompras_attributes] = dsc_rcg_global
        documento[:imptoretencompras_attributes] = ir
        documento[:mpagocompras_attributes] = montos_pago

        p = Hash.new
        p[:documento] = documento
        
        @docCompra = Doccompra.new(p[:documento])
        @docCompra.xmlrecibido = docEmail.xmlrecibido

        @docCompra.TED = doc['TED'].to_xml


        if @docCompra.save
          docEmail.estado = 'PROCESADO'
          docEmail.save
        end  
    #rescue 
      docEmail.estado = 'ERROR'
      docEmail.id
      docEmail.save
    #end    
  end
end