# encoding: ISO-8859-1
class Api::V1::DoccompraController < Api::V1::ApiController
  def procesarecibo
    demail = Docsemail.where(estado: "RECIBIDO").first

    @doc_xml = 'PROCESADO' 
    unless demail.nil?
       
      json= Hash.from_xml(demail.xmlrecibido)

      if json['EnvioDTE']['SetDTE']['DTE'].kind_of?(Array)
        json['EnvioDTE']['SetDTE']['DTE'].each do  |dte|  
          procesadoc(dte,demail)
        end
      else
        procesadoc(json['EnvioDTE']['SetDTE']['DTE'],demail)
      end

      @doc_xml = "OK"
      
      render 'api/v1/doccompra/procesarecibo'
    end  
  end

  def procesadoc(dte, docEmail)
        doc = dte['Documento']

        idDoc = doc['Encabezado']['IdDoc']
        idDoc.delete("FchCancel")
        idDoc.delete("MedioPago")
        idDoc.delete("TermPagoDias")


        emisor = doc['Encabezado']['Emisor']
        receptor = doc['Encabezado']['Receptor']
        totales = doc['Encabezado']['Totales']
        _detalles = doc['Detalle']
        referencia = doc['Referencia']
        comisiones = doc['Comisiones']
        dsc_rcg_global = doc['DscRcgGlobal']
        impuesto_reten = totales['ImptoReten']
        montos_pago = doc['MntPagos']
        idDoc.delete("MntPagos")
        totales.delete("ImptoReten")

        documento = idDoc.merge(emisor).merge(receptor).merge(totales)

       
        detalles = Array.new
        cdgI = Hash.new
        #subD = Hash.new
        if _detalles .kind_of?(Array)
          _detalles.each do |det|
 
            if det["CdgItem"].kind_of?(Array)
              cdgI = det["CdgItem"].first
            else
              cdgI = det["CdgItem"]
            end   
            det.delete("CdgItem")
          
            subD = det["SubDscto"]
            if subD.nil?
              subD={}
            else    
              det.delete("SubDscto")
              detalles << subD
            end  
            detalles << det.merge(cdgI)
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
          detalles << det.merge(cdgI)
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
        #if montos_pago.nil? 
          montos_pago = [{}] 
        #end

        documento[:detcompras_attributes] = detalles
        documento[:refdetcompras_attributes] = r
        documento[:comisioncompras_attributes] = comisiones
        documento[:dscrcgglobalcompras_attributes] = dsc_rcg_global
        documento[:imptoretencompras_attributes] = ir
        documento[:mpagocompras_attributes] = montos_pago

        p = Hash.new
        p[:documento] = documento

        puts "============="
        puts p[:documento]
        puts "============="

        
        @docCompra = Doccompra.new(p[:documento])
        @docCompra.xmlrecibido = docEmail.xmlrecibido

        if @docCompra.save
          docEmail.estado = 'PROCESADO'
          docEmail.save
        end  
  end
end