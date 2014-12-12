# encoding: ISO-8859-1
class Api::V1::DocumentoController < Api::V1::ApiController

  def create_doc

    #TO DO:  pdf y pdfcedible en tabla documento 
    #para recibir toda la info (Ver si es recomendable el envío por separado)

    #TO DO: llamar a connect sii para realizar el envío a SII

    p = eval(params[:doc].force_encoding('iso-8859-1').encode('utf-8'))


    @invoice = Documento.new( p[:documento] ) 
    @invoice.envio = params[:xml]
    @invoice.fileEnvio = params[:filename]
    @invoice.estado = "CREADO"

    if @invoice.save

      File.open(@invoice.fileEnvio, 'w') { |file| file.puts @invoice.envio}

      sleep 2

      #if(params[:conenvio] == 1)
        postsii(@invoice.id)
      #   if(enviado)
      #     @invoice.estado = "ENVIADO"
      #   else
      #     @invoice.estado = "PENDIENTE"
      #   end
      #   @invoice.save
      # end  

      render 'api/v1/invoices/create' 
    else
       render format.json { render json: @invoice.errors, status: :unprocessable_entity }
    end
  end 

 

  def postsii(idDoc)
    @doc  = Documento.find(idDoc)

    @token = get_token 

    @rut = @doc.RUTEmisor[0..7]
    @dv  = @doc.RUTEmisor[9..9]


    if @token

      @BOUNDARY = "-----------------9022632e1130lc4--"
   
      uri = URI.parse("https://palena.sii.cl/cgi_dte/UPL/DTEUpload") 
    
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_PEER

      request = Net::HTTP::Post.new(uri.request_uri) 

      post_body = []

      post_body << "-----------------9022632e1130lc4\r\n"
      post_body << "Content-Disposition: form-data; name=\"rutSender\"\r\n"
      post_body << "Content-Type: text/plain; charset=US-ASCII\r\n"
      post_body << "Content-Transfer-Encoding: 8Bit\r\n"
      post_body << "\r\n"
      post_body << "05682509\r\n"
      post_body << "-----------------9022632e1130lc4\r\n"
      post_body << "Content-Disposition: form-data; name=\"dvSender\"\r\n"
      post_body << "Content-Type: text/plain; charset=US-ASCII\r\n"
      post_body << "Content-Transfer-Encoding: 8Bit\r\n"
      post_body << "\r\n"
      post_body << "6\r\n"
      post_body << "-----------------9022632e1130lc4\r\n"
      post_body << "Content-Disposition: form-data; name=\"rutCompany\"\r\n"
      post_body << "Content-Type: text/plain; charset=US-ASCII\r\n"
      post_body << "Content-Transfer-Encoding: 8Bit\r\n"
      post_body << "\r\n"
      post_body << "#{@rut}\r\n"
      post_body << "-----------------9022632e1130lc4\r\n"
      post_body << "Content-Disposition: form-data; name=\"dvCompany\"\r\n"
      post_body << "Content-Type: text/plain; charset=US-ASCII\r\n"
      post_body << "Content-Transfer-Encoding: 8Bit\r\n"
      post_body << "\r\n"
      post_body << "#{@dv}\r\n"

          
      post_body << "-----------------9022632e1130lc4\r\n"
      post_body << "Content-Disposition: form-data; name=\"archivo\"; filename=\"#{@doc.fileEnvio}\"\r\n"
      post_body << "Content-Type: application/octet-stream\r\n"
      post_body << "Content-Transfer-Encoding: binary\r\n"
    
      envioxml = File.read @doc.fileEnvio 
       
      post_body << "\r\n"
      post_body << envioxml
      post_body << "\r\n"
      post_body << "-----------------9022632e1130lc4\r\n"
    
      request.body = post_body.join


      request["Accept"]          = "image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, application/vnd.ms-powerpoint, application/ms-excel, application/msword, */*"
      request["Referer"]         = "http://www.empresa.cl"
      request["Accept-Language"] = "es-cl"
      request["Content-Type"]    = "multipart/form-data: boundary=#{@BOUNDARY}"
      request["Accept-Encoding"] = "gzip, deflate"
      request["User-Agent"]      = "Mozilla/4.0 (compatible; PROG 1.0; Windows NT 5.0; YComp 5.0.2.4)"
      request["Content-Length"]  = request.body.length
      request["Connection"]      = "Keep-Alive"
      request["Cache-Control"]   = "no-cache"
      request["Cookie"]          = "TOKEN=#{@token}"
      
      responce = http.request(request)
      puts "===================================="
      puts post_body
      puts "===================================="
      puts responce.body
      puts "===================================="
    
      return true 
    else
      return false
    end    
  end


  def get_token
   
    i=0
    while(!@seed || i<20)
      @seed= getseed
      i+=1
    end


    if @seed
   
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


      File.open('tosign_xml.xml', 'w') { |file| file.puts tosign_xml}
      sleep 1
     
      system("./comando")
      
      
      doc = File.read 'doc-signed.xml'

      i=0
      while(!@token || i<20)
        @token= gettoken(doc)
        i+=1
      end
      
   
      if @token
        @token= @token.to_s[@token.to_s.index('TOKEN')+9..@token.to_s.index('TOKEN')+21]
        return @token 
      else
        return nil 
    
      end 
    else
      return nil  
    end

  end

  def getseed
    begin
      # ambiente sii pruebas 
      # client = Savon.client(wsdl:"https://maullin.sii.cl/DTEWS/CrSeed.jws?WSDL") 
      #produccion
      client = Savon.client(wsdl:"https://palena.sii.cl/DTEWS/CrSeed.jws?WSDL") 
      @seed_xml = client.call(:get_seed)

      @seed= @seed_xml.to_s[@seed_xml.to_s.index('SEMILLA')+11..@seed_xml.to_s.index('SEMILLA')+22]

      return @seed

    rescue
      puts "=====SEED========"
      puts "Error #{$!}"
      puts "============="
      @seed=nil

    ensure 
    end
  end

  def gettoken(seed_xml)
    begin
      #tokenws = Savon.client(wsdl: "https://maullin.sii.cl/DTEWS/GetTokenFromSeed.jws?WSDL")
      tokenws = Savon.client(wsdl: "https://palena.sii.cl/DTEWS/GetTokenFromSeed.jws?WSDL")
      @token = tokenws.call( :get_token , message: {string: seed_xml}) 
    rescue
      puts "=====TOKEN========"
      puts "Error #{$!}"
      puts "============="
      @token=nil
    ensure 
    end
  end

end
