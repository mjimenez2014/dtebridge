# encoding: ISO-8859-1
class Api::V1::DocumentoController < Api::V1::ApiController
  
  def create_doc

    p = eval(params[:doc].force_encoding('iso-8859-1').encode('utf-8'))

    if params[:Folio].present? 
      @invoice =Documento.where(Folio: params[:Folio]).first
      if @invoice.nil?
        @invoice = Documento.new( p[:documento] )
        @invoice.estado = "CREADO"
        @invoice.estadoxml = "NO ENVIADO"
      end
    else
      @invoice = Documento.new( p[:documento] )
      @invoice.estado = "CREADO"
      @invoice.estadoxml = "NO ENVIADO"  
    end 

    @invoice.pdfs = params[:pdfCed]
    @invoice.pdft = params[:pdfTrib]
    @invoice.fileEnvio = params[:xmlFile]

    if params[:fileCliente].present?
      @invoice.fileCliente = params[:fileCliente] 
    end

    if params[:fileFactura].present?
      @invoice.fileFactura = params[:fileFactura]
    end  
    
    if params[:fileJson].present?
      @invoice.fileJson = params[:fileJson]
    end

   
    if @invoice.save
      if !params[:conEnvio].present? || params[:conEnvio] == "S"
        @invoice.estadoxml = postsii(@invoice.id)
        trackid = @invoice.estadoxml.to_s[estadoxml.to_s.index('TRACKID')+8..estadoxml.to_s.index('/TRACKID')-2]
        @invoice.trackidSII = trackid
        @invoice.save       
        estadoStr(@invoice)
      end

      render 'api/v1/invoices/create' 
    else
      render 'api/v1/invoices/error'
    end
  end 

  def resend
    invoices = Documento.where(estado: "CREADO").where(:created_at => 30.days.ago..Time.now)
    invoices.each do |invoice| 
      invoice.estadoxml = postsii(invoice.id)
      invoice.save   
      if invoice.save    
        estadoStr(invoice)
      end  
    end
    render 'api/v1/invoices/create' 
  end 

  def postsii(idDoc)
    @doc  = Documento.find(idDoc)

    @tokenOk = get_token(@doc.RUTEmisor) 

    @rut = @doc.RUTEmisor[0..7]
    @dv  = @doc.RUTEmisor[9..9]


    unless @token.nil?

      @BOUNDARY = "9022632e1130lc4"
   
      uri = URI.parse("https://palena.sii.cl/cgi_dte/UPL/DTEUpload") 
     # uri = URI.parse("https://maullin2.sii.cl/cgi_dte/UPL/DTEUpload") 

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_PEER

      request = Net::HTTP::Post.new(uri.request_uri) 

      post_body = []

      post_body << "--9022632e1130lc4\r\n"
      post_body << "Content-Disposition: form-data; name=\"rutSender\"\r\n"
      post_body << "Content-Type: text/plain; charset=US-ASCII\r\n"
      post_body << "Content-Transfer-Encoding: 8Bit\r\n"
      post_body << "\r\n"
      post_body << "05682509\r\n"
      post_body << "--9022632e1130lc4\r\n"
      post_body << "Content-Disposition: form-data; name=\"dvSender\"\r\n"
      post_body << "Content-Type: text/plain; charset=US-ASCII\r\n"
      post_body << "Content-Transfer-Encoding: 8Bit\r\n"
      post_body << "\r\n"
      post_body << "6\r\n"
      post_body << "--9022632e1130lc4\r\n"
      post_body << "Content-Disposition: form-data; name=\"rutCompany\"\r\n"
      post_body << "Content-Type: text/plain; charset=US-ASCII\r\n"
      post_body << "Content-Transfer-Encoding: 8Bit\r\n"
      post_body << "\r\n"
      post_body << "#{@rut}\r\n"
      post_body << "--9022632e1130lc4\r\n"
      post_body << "Content-Disposition: form-data; name=\"dvCompany\"\r\n"
      post_body << "Content-Type: text/plain; charset=US-ASCII\r\n"
      post_body << "Content-Transfer-Encoding: 8Bit\r\n"
      post_body << "\r\n"
      post_body << "#{@dv}\r\n"

          
      post_body << "--9022632e1130lc4\r\n"
      post_body << "Content-Disposition: form-data; name=\"archivo\"; filename=\"#{@doc.fileEnvio}\"\r\n"
      post_body << "Content-Type: /xml\r\n" 

      envio_xml = @doc.fileEnvio.read
       
      post_body << "\r\n"
      post_body << envio_xml
      post_body << "\r\n"
      post_body << "--9022632e1130lc4--\r\n"
    
      request.body = post_body.join

      request["Accept"]          = "image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, application/vnd.ms-powerpoint, application/ms-excel, application/msword, */*"
      request["Referer"]         = "http://www.lubba.cl"
      request["Accept-Language"] = "es-cl"
      request["Content-Type"]    = "multipart/form-data: boundary=#{@BOUNDARY}"
      request["Accept-Encoding"] = "gzip, deflate"
      request["User-Agent"]      = "Mozilla/4.0 (compatible; PROG 1.0; Windows NT 5.0; YComp 5.0.2.4)"
      request["Content-Length"]  = request.body.length
      request["Connection"]      = "Keep-Alive"
      request["Cache-Control"]   = "no-cache"
      request["Cookie"]          = "TOKEN=#{@tokenOk}"
    
      responce = http.request(request)
      puts "===================================="
      puts request.body
      puts "===================================="
      puts responce.body
      puts "===================================="

      return responce.body
    else
      return "ERROR"
    end    
  end



  def get_token(rut)
   
    i=0
    while(@seed.nil? && i<50)
      @seed= getseed
      sleep 1
      i+=1
    end

    unless @seed.nil?
   
      tosign_xml="<gettoken><item><Semilla>#{@seed}</Semilla></item>"
      tosign_xml+="<Signature xmlns=\"http://www.w3.org/2000/09/xmldsig#\">"
      tosign_xml+=  "<SignedInfo>"
      tosign_xml+=   "<CanonicalizationMethod Algorithm=\"http://www.w3.org/TR/2001/REC-xml-c14n-20010315\"/>"
      tosign_xml+=    "<SignatureMethod Algorithm=\"http://www.w3.org/2000/09/xmldsig#rsa-sha1\"/>"
      tosign_xml+=     "<Reference URI=\"\">"
      tosign_xml+=      "<Transforms>"
      tosign_xml+=         "<Transform Algorithm=\"http://www.w3.org/2000/09/xmldsig#enveloped-signature\"/>"
      tosign_xml+=      "</Transforms>"
      tosign_xml+=      "<DigestMethod Algorithm=\"http://www.w3.org/2000/09/xmldsig#sha1\"/>"
      tosign_xml+=      "<DigestValue/>"
      tosign_xml+=     "</Reference>"
      tosign_xml+=  "</SignedInfo>"
      tosign_xml+=  "<SignatureValue/>"
      tosign_xml+=  "<KeyInfo>"
      tosign_xml+=   "<KeyValue/>"
      tosign_xml+=   "<X509Data>"
      tosign_xml+=    "<X509SubjectName/>"
      tosign_xml+=    "<X509IssuerSerial/>"
      tosign_xml+=    "<X509Certificate/>"
      tosign_xml+=   "</X509Data>"
      tosign_xml+=  "</KeyInfo>"
      tosign_xml+= "</Signature>"
      tosign_xml+="</gettoken>"

      t = Time.now.strftime("%Y%d%m%H%M%S")

      File.open("tosign_xml#{t}.xml", 'w') { |file| file.puts tosign_xml}
      sleep 1
     
      system("./comando#{rut} tosign_xml#{t}.xml doc-signed#{t}.xml")

      doc = File.read "doc-signed#{t}.xml"

      system("rm tosign_xml#{t}.xml") 
      system("rm doc-signed#{t}.xml")

      i=0
      while(@token.nil? && i<50)
        @token= gettoken(doc)
        sleep 1
        i+=1
      end
      
      puts "=====TOKEN OK========"
      puts @token
      puts "============="
   
      unless @token.nil?
        if @token.to_s.index('TOKEN') != nil
          @token= @token.to_s[@token.to_s.index('TOKEN')+9..@token.to_s.index('TOKEN')+21]
        end  
        return @token
        #render 'api/v1/invoices/token' 
      else
        return nil 
       # render format.json { render json: '{ERROR}', status: :unprocessable_entity }
      end 
    else
      return nil
      #render format.json { render json: '{}', status: :unprocessable_entity }  
    end

  end

  def getseed
    begin
      # ambiente sii pruebas 
      #client = Savon.client(wsdl:"https://maullin2.sii.cl/DTEWS/CrSeed.jws?WSDL") 
      #produccion
      client = Savon.client(wsdl:"https://palena.sii.cl/DTEWS/CrSeed.jws?WSDL") 
      seed_xml = client.call(:get_seed)

      seed= seed_xml.to_s[seed_xml.to_s.index('SEMILLA')+11..seed_xml.to_s.index('SEMILLA')+22]


      puts "=====SEED OK========"
      puts seed_xml
      puts seed
      puts "============="

      return seed

    rescue
      puts "=====SEED========"
      puts "Error #{$!}"
      puts "============="
      seed=nil

    ensure 
    end
  end

  def gettoken(seed_xml)
    begin

      puts "=====SEED XML========"
      puts seed_xml
      puts "============="

      #tokenws = Savon.client(wsdl: "https://maullin2.sii.cl/DTEWS/GetTokenFromSeed.jws?WSDL")
      tokenws = Savon.client(wsdl: "https://palena.sii.cl/DTEWS/GetTokenFromSeed.jws?WSDL")
      token = tokenws.call( :get_token , message: {string: seed_xml}) 

      puts "=====TOKEN========"
      puts "OBTENIDO"
      puts token
      puts "============="

      return token

    rescue
      puts "=====TOKEN========"
      puts "Error #{$!}"
      puts "============="
      token=nil
    ensure 
    end
  end

  def estadoStr(id)
    d = Documento.find(id)
    estadoxml = d.estadoxml
    statusUp= estadoxml.to_s[estadoxml.to_s.index('STATUS')+7..estadoxml.to_s.index('/STATUS')-2]

    estado= { "0" => "0 Upload Ok",
              "1" => "1 Sender no tiene permisos para enviar",
              "2" => "2 Error en tamaño de Archivo",
              "3" => "3 Archivo Cortado",
              "4" => "4 No definido",
              "5" => "5 No esta Autenticado",
              "6" => "6 Empresa no autorizada",
              "7" => "7 Esquema invalido",
              "8" => "8 Error en Firma",
              "9" => "9 Sistema Bloqueado" ,
              "Otro" => "Error interno SII"
            }
    d.estado = estado[statusUp] 
    d.save 
            
    if d.estadoEnvioXml.to_s.index('ACEPTADOS').nil?   
      
    else      
      aceptados = d.estadoEnvioXml.to_s[d.estadoEnvioXml.to_s.index('ACEPTADOS')+13..d.estadoEnvioXml.to_s.index('/ACEPTADOS')-5]
      rechazados = d.estadoEnvioXml.to_s[d.estadoEnvioXml.to_s.index('RECHAZADOS')+14..d.estadoEnvioXml.to_s.index('/RECHAZADOS')-5]
      reparos = d.estadoEnvioXml.to_s[d.estadoEnvioXml.to_s.index('REPAROS')+11..d.estadoEnvioXml.to_s.index('/REPAROS')-5]

      if rechazados == "1"
        d.estado = "Rechazado SII"
        d.save 
      end  
      if aceptados == "1"
        d.estado = "Aceptado Ok SII" 
        d.save 
        enviaEmailCliente(d.RUTRecep,id)
      end
      if reparos == "1"
        d.estado = "Aceptado con Reparos"
        d.save 
        enviaEmailCliente(d.RUTRecep,id)
      end 
    end
  end

  def consultaEnvio( docId, rut, dv, estadoxml, token)
    begin
      trackId = estadoxml.to_s[estadoxml.to_s.index('TRACKID')+8..estadoxml.to_s.index('/TRACKID')-2]
      estadoWs = Savon.client(wsdl: "https://palena.sii.cl/DTEWS/QueryEstUp.jws?WSDL")
      estado = estadoWs.call( :get_est_up , message: {RutCompania: rut, DvCompania: dv, TrackId: trackId, Token: token})

      # #estado = estadoWs.call( :get_est_up , message: {RutCompania: '77888630', DvCompania: '8', TrackId: '0878885016', Token: 'BCTTCTEYZnzrM'})

      puts "======================="
      puts estado
      puts "======================="
      docum = Documento.find(docId)
      docum.estadoEnvioXml = estado.to_s
      docum.save
      return estado.to_s
    rescue 
      return nil
    end
  end

  def procesoEstado
      listDoc = Documento.where(estado: "0 Upload Ok").limit(10)
      listDoc.each do |doc|
        token = get_token(doc.RUTEmisor)
        unless  token.nil?
          consultaEnvio(doc.id, doc.RUTEmisor[0..7], doc.RUTEmisor[9..9], doc.estadoxml,token)
          estadoStr(doc.id)
        end      
      end
    render "/api/v1/iat/ping"  
  end  

  def sendclient
    folio = params[:folio]
    rut = params[:rut]
    tipo = params[:tipodte]
    doc = Documento.where(Folio: folio).where(RUTEmisor: rut).where(TipoDTE: tipo).first
    unless doc.fileCliente.nil?
      enviaEmailCliente(doc.RUTRecep, doc.id)
    end
    render "/api/v1/iat/ping"  
  end


  def enviaEmailCliente(rut,id)
    #Busca email en modelo contribuyentes
    contrib = Contribuyente.find_by_rut(rut)
    unless contrib.nil?
      NotificationMailer.notification_email(contrib.email, id).deliver
    end
  end
end

