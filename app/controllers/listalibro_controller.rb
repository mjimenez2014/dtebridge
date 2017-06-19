class ListalibroController < ApplicationController
  def index
    searchparams = params["/libros"]
    if searchparams.present?
      if searchparams[:search] != ""
        @search = Libro.search do
          fulltext searchparams[:search]
        end
        @libros = @search.results
      else
        @libros = Libro.where(:rut => Usuarioempresa.where(useremail:current_user.email).map {|u| u.rutempresa}).order(:rut,:idenvio) 
      end  
    else  
      @libros = Libro.where(:rut => Usuarioempresa.where(useremail:current_user.email).map {|u| u.rutempresa}).order(:rut,:idenvio)   
    end

  end

  def genxml
    lib = Libro.find(params[:id])
    #puts lib.id
    lib.xml
    lib.estado = "XML Generado"
    lib.enviado = "NO"
    lib.save
    
    @libros = Libro.where(:rut => Usuarioempresa.where(useremail:current_user.email).map {|u| u.rutempresa}).order(:rut,:idenvio)
    respond_to do |format|
      format.html { render action: 'index' }
    end 
  end

  def sendxml
    libro = Libro.find(params[:id])
    if libro.tipo == "VENTA"
      send_file "#{Rails.root}/libro_venta#{libro.rut}#{libro.idenvio}.xml"
    else
      send_file "#{Rails.root}/libro_compra#{libro.rut}#{libro.idenvio}.xml"
    end

  end  

  def sendsii
    libro = Libro.find(params[:id])
    if libro.enviado = "NO"
      libro.estadoxml = postsii(libro.id)
      libro.enviado = "0 Upload Ok"
      libro.save
    end
    @libro = Libro.where(:rut => Usuarioempresa.where(useremail:current_user.email).map {|u| u.rutempresa}).order(:rut,:idenvio)
    respond_to do |format|
      format.html { render action: 'index' }
    end 
  end


  def postsii(idLibro)
    libro  = Libro.find(idLibro)

    @tokenOk = get_token(libro.rut) 

    @rut = libro.rut[0..7]
    @dv  = libro.rut[9..9]

    unless @token.nil?

      @BOUNDARY = "9022632e1130lc4"
   
      # if Rails.env.production?
        uri = URI.parse("https://palena.sii.cl/cgi_dte/UPL/DTEUpload") 
      # else
      #   uri = URI.parse("https://maullin2.sii.cl/cgi_dte/UPL/DTEUpload") 
      # end

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

      if libro.tipo == "VENTA"
        fileEnvio = "#{Rails.root}/libro_venta#{libro.rut}#{libro.idenvio}.xml"
      else
        fileEnvio = "#{Rails.root}/libro_compra#{libro.rut}#{libro.idenvio}.xml"
      end
          
      post_body << "--9022632e1130lc4\r\n"
      post_body << "Content-Disposition: form-data; name=\"archivo\"; filename=\"#{fileEnvio}\"\r\n"
      post_body << "Content-Type: /xml\r\n" 

      envio_xml = File.read fileEnvio
       
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
      #puts "===================================="
      #puts request.body
      #puts "===================================="
      #puts responce.body
      #puts "===================================="

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

      # Se agregará un comando para cada cliente mientras se resuelve como solucionar
      # if Empresa.last.rut == "80790400-0"
      #   #puts "============"
      #   #puts "ElSultan"
      #   #puts "============"
      #   system("./comandoElSultan tosign_xml#{t}.xml doc-signed#{t}.xml")
      # else  
      #   system("./comando tosign_xml#{t}.xml doc-signed#{t}.xml")
      #   #puts "============"
      #   #puts "Otros"
      #   #puts "============"
      # end

      system("rm tosign_xml#{t}.xml") 
      system("rm doc-signed#{t}.xml")

      i=0
      while(@token.nil? && i<50)
        @token= gettoken(doc)
        sleep 1
        i+=1
      end
      
      #puts "=====TOKEN OK========"
      #puts @token
      #puts "============="
   
      unless @token.nil?
        @token= @token.to_s[@token.to_s.index('TOKEN')+9..@token.to_s.index('TOKEN')+21]
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
      # if Rails.env.production?
        client = Savon.client(wsdl:"https://palena.sii.cl/DTEWS/CrSeed.jws?WSDL") 
      # else
      #   client = Savon.client(wsdl:"https://maullin2.sii.cl/DTEWS/CrSeed.jws?WSDL")
      # end  
      seed_xml = client.call(:get_seed)

      seed= seed_xml.to_s[seed_xml.to_s.index('SEMILLA')+11..seed_xml.to_s.index('SEMILLA')+22]


      #puts "=====SEED OK========"
      #puts seed_xml
      #puts seed
      #puts "============="

      return seed

    rescue
      #puts "=====SEED========"
      #puts "Error #{$!}"
      #puts "============="
      seed=nil

    ensure 
    end
  end

  def gettoken(seed_xml)
    begin

      #puts "=====SEED XML========"
      #puts seed_xml
      #puts "============="

      # if Rails.env.production?
        tokenws = Savon.client(wsdl: "https://palena.sii.cl/DTEWS/GetTokenFromSeed.jws?WSDL")
      # else
      #   tokenws = Savon.client(wsdl: "https://maullin2.sii.cl/DTEWS/GetTokenFromSeed.jws?WSDL")
      # end
      token = tokenws.call( :get_token , message: {string: seed_xml}) 

      #puts "=====TOKEN========"
      #puts "OBTENIDO"
      #puts token
      #puts "============="

      return token

    rescue
      #puts "=====TOKEN========"
      #puts "Error #{$!}"
      #puts "============="
      token=nil
    ensure 
    end
  end

end
