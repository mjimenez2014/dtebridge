    # encoding: ISO-8859-1
class DoccomprasController < ApplicationController
  before_action :set_doccompra, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    searchparams = params["/doccompras"]
    if searchparams.present?
      if searchparams[:search] != ""
          search = Doccompra.where(RUTEmisor: searchparams[:rutemis]).where(estado: nil).all do
          fulltext searchparams[:search]
          order_by(:created_at, :desc)
          paginate :page => 1, :per_page => 500
        end
        @doccompras = search
        @doccompras = Doccompra.where(:RUTRecep => Usuarioempresa.where(useremail:current_user.email).map {|u| u.rutempresa}).where(id: search.map(&:id)).order(created_at: :desc).paginate(:page => params[:page], :per_page => 15 )
      else
        @doccompras = Doccompra.where(:RUTRecep => Usuarioempresa.where(useremail:current_user.email).map {|u| u.rutempresa}).where(estado: nil).order(created_at: :desc).paginate(:page => params[:page], :per_page => 15 )
      end  
    else  
      @doccompras = Doccompra.where(:RUTRecep => Usuarioempresa.where(useremail:current_user.email).map {|u| u.rutempresa}).where(estado: nil).order(created_at: :desc).paginate(:page => params[:page], :per_page => 15 )
    end
  end

  def print
    @doccompra = Doccompra.find(params[:id])
     respond_to do |format|
         format.html 
         format.pdf do  
            render pdf: "terms", 
            formats: :html, 
            encoding: "UTF-8",
            template: "doccompras/print.html.erb",
            layout: "pdf.html.erb"
         end
     end
  # Excluding ".pdf" extension.
  end
 
  def import
    #recupero el archivo del formulario
    file_data = params[:file]
    file_content = file_data.read
    puts "-----    XML    ------------"
    puts file_content
    d = Docsemail.new
    d.xmlrecibido = file_content
    d.mailid = "Carga Manual"
    d.estado = "RECIBIDO"
    d.save
    respond_to do |format|
        format.html { redirect_to :back}
    end
  end

  
  def ver
    @doccompra = Doccompra.find(params[:id])
       respond_to do |format|
         format.html 
    end
  end

  def rechazar
    d = Doccompra.find(params[:id])

        
    # xml rechazo
    tosign_xml="<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>"
    tosign_xml+="<RespuestaDTE xmlns=\"http://www.sii.cl/SiiDte\" xmlns:ds=\"http://www.w3.org/2000/09/xmldsig\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" version=\"1.0\" xsi:schemaLocation=\"http://www.sii.cl/SiiDte RespuestaEnvioDTE_v10.xsd\">"
    tosign_xml+="  <Resultado ID=\"ResultadoDTE\">"
    tosign_xml+="    <Caratula version=\"1.0\">"
    tosign_xml+="      <RutResponde>" + d.RUTRecep + "</RutResponde>"
    tosign_xml+="     <RutRecibe>" + d.RUTEmisor + "</RutRecibe>"
    tosign_xml+="      <IdRespuesta>1</IdRespuesta>"
    tosign_xml+="      <NroDetalles>2</NroDetalles>"
    tosign_xml+="      <TmstFirmaResp>2014-11-27T00:00:00</TmstFirmaResp>"
    tosign_xml+="    </Caratula>"
    tosign_xml+="    <ResultadoDTE>"
    tosign_xml+="      <TipoDTE>" + d.TipoDTE.to_s + "</TipoDTE>"
    tosign_xml+="      <Folio>" + d.Folio.to_s + "</Folio>"
    tosign_xml+="      <FchEmis>" + d.FchEmis + "</FchEmis>"
    tosign_xml+="      <RUTEmisor>" + d.RUTEmisor + "</RUTEmisor>"
    tosign_xml+="      <RUTRecep>" + d.RUTRecep + "</RUTRecep>"
    tosign_xml+="      <MntTotal>" + d.MntTotal.to_s + "</MntTotal>"
    tosign_xml+="      <CodEnvio>" + d.TipoDTE.to_s + "</CodEnvio>"
    tosign_xml+="      <EstadoDTE>3</EstadoDTE>"
    tosign_xml+="      <RecepDTEGlosa>DTE No Recibido - Error</RecepDTEGlosa>"
    tosign_xml+="   </ResultadoDTE>"
    tosign_xml+="  </Resultado>"
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
    tosign_xml+="</RespuestaDTE>"

    t = Time.now.strftime("%Y%d%m%H%M%S")
    rut = d.RUTRecep

    File.open("tosign_xml#{t}.xml", 'w') { |file| file.puts tosign_xml}
    sleep 1
     
    system("./comando#{rut} tosign_xml#{t}.xml doc-signed#{t}.xml")

    doc = File.read "doc-signed#{t}.xml"

    #enviar doc por mail

    system("rm tosign_xml#{t}.xml") 
    #system("rm doc-signed#{t}.xml")

    d.estado = "RECHAZADO"
    d.save
    @doccompras = Doccompra.where(estado: nil).where(:RUTRecep => Usuarioempresa.where(useremail:current_user.email).map {|u| u.rutempresa})
    respond_to do |format|
        format.html { redirect_to :back}
    end    
  end

  def aprobar
    d = Doccompra.find(params[:id])
    t = Time.now.strftime("%Y%d%m%H%M%S")
    tf = Time.now.strftime("%Y-%m-%dT%H:%M:%S")

    # xml Aceptado
    tosign_xml="<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>\r\n"
    tosign_xml+="<RespuestaDTE xmlns=\"http://www.sii.cl/SiiDte\" xmlns:ds=\"http://www.w3.org/2000/09/xmldsig\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" version=\"1.0\" xsi:schemaLocation=\"http://www.sii.cl/SiiDte RespuestaEnvioDTE_v10.xsd\">\r\n"
    tosign_xml+="  <Resultado ID=\"ResultadoDTE\">\r\n"
    tosign_xml+="    <Caratula version=\"1.0\">\r\n"
    tosign_xml+="      <RutResponde>" + d.RUTRecep + "</RutResponde>\r\n"
    tosign_xml+="      <RutRecibe>" + d.RUTEmisor + "</RutRecibe>\r\n"
    tosign_xml+="      <IdRespuesta>1</IdRespuesta>\r\n"
    tosign_xml+="      <TmstFirmaResp>" + tf + "</TmstFirmaResp>\r\n"
    tosign_xml+="    </Caratula>\r\n"
    tosign_xml+="    <RecepcionEnvio>\r\n"
    tosign_xml+="      <NmbEnvio>doc-signed"+ t +".xml</NmbEnvio>\r\n"
    tosign_xml+="      <FchRecep>" + d.FchEmis + "</FchRecep>\r\n"
    tosign_xml+="      <CodEnvio>" + d.Folio.to_s + d.TipoDTE.to_s + "</CodEnvio>\r\n"
    tosign_xml+="      <EnvioDTEID>EDTE1204264D81279882</EnvioDTEID>\r\n"
    tosign_xml+="      <RutEmisor>" + d.FchEmis + "</RutEmisor>\r\n"
    tosign_xml+="      <RutReceptor>" + d.RUTRecep + "</RutReceptor>\r\n"
    tosign_xml+="      <EstadoRecepEnv>0</EstadoRecepEnv>\r\n"
    tosign_xml+="      <RecepEnvGlosa>Envio Recibido Conforme</RecepEnvGlosa>\r\n"
    tosign_xml+="      <NroDTE>1</NroDTE>\r\n"
    tosign_xml+="         <RecepcionDTE>\r\n"
    tosign_xml+="           <TipoDTE>" + d.TipoDTE.to_s + "</TipoDTE>\r\n"
    tosign_xml+="           <Folio>" + d.Folio.to_s + "</Folio>\r\n"
    tosign_xml+="           <FchEmis>" + d.FchEmis + "</FchEmis>\r\n"
    tosign_xml+="           <RUTEmisor>"+ d.RUTEmisor + "</RUTEmisor>\r\n"
    tosign_xml+="           <RUTRecep>" + d.RUTRecep + "</RUTRecep>\r\n"
    tosign_xml+="           <MntTotal>" + d.MntTotal.to_s + "</MntTotal>\r\n"
    tosign_xml+="           <CodEnvio>339734</CodEnvio>\r\n"
    tosign_xml+="           <EstadoDTE>0</EstadoDTE>\r\n"
    tosign_xml+="           <RecepDTEGlosa>DTE Aceptado OK</RecepDTEGlosa>\r\n"
    tosign_xml+="        </RecepcionDTE>\r\n"
    tosign_xml+="   </RecepcionEnvio>\r\n"
    tosign_xml+="  </Resultado>\r\n"
    tosign_xml+="<Signature xmlns=\"http://www.w3.org/2000/09/xmldsig#\">\r\n"
    tosign_xml+=  "<SignedInfo>\r\n"
    tosign_xml+=   "<CanonicalizationMethod Algorithm=\"http://www.w3.org/TR/2001/REC-xml-c14n-20010315\"/>\r\n"
    tosign_xml+=    "<SignatureMethod Algorithm=\"http://www.w3.org/2000/09/xmldsig#rsa-sha1\"/>\r\n"
    tosign_xml+=     "<Reference URI=\"\">\r\n"
    tosign_xml+=      "<Transforms>\r\n"
    tosign_xml+=         "<Transform Algorithm=\"http://www.w3.org/2000/09/xmldsig#enveloped-signature\"/>\r\n"
    tosign_xml+=      "</Transforms>\r\n"
    tosign_xml+=      "<DigestMethod Algorithm=\"http://www.w3.org/2000/09/xmldsig#sha1\"/>\r\n"
    tosign_xml+=      "<DigestValue/>\r\n"
    tosign_xml+=     "</Reference>\r\n"
    tosign_xml+=  "</SignedInfo>\r\n"
    tosign_xml+=  "<SignatureValue/>\r\n"
    tosign_xml+=  "<KeyInfo>\r\n"
    tosign_xml+=   "<KeyValue/>\r\n"
    tosign_xml+=   "<X509Data>\r\n"
    tosign_xml+=    "<X509SubjectName/>\r\n"
    tosign_xml+=    "<X509IssuerSerial/>\r\n"
    tosign_xml+=    "<X509Certificate/>\r\n"
    tosign_xml+=   "</X509Data>\r\n"
    tosign_xml+=  "</KeyInfo>\r\n"
    tosign_xml+= "</Signature>\r\n"
    tosign_xml+="</RespuestaDTE>\r\n"


    File.open("inter_tosign_xml#{t}.xml", 'w') { |file| file.puts tosign_xml}
    sleep 1
     
    system("./comando#{d.RUTRecep} inter_tosign_xml#{t}.xml inter_doc-signed#{t}.xml")

    #enviar doc por mail
    contrib = Contribuyente.find_by_rut(d.RUTEmisor)
    if contrib.nil?
    else    
        if Rails.env.production?
            email = contrib.email
        else
            email = "soporte@invoicedigital.cl"
        end   
    #   NotificationMailer.send_intercambio("osvaldo.omiranda@gmail.com", d.id, d.RUTRecep, "inter_doc-signed#{t}.xml" ).deliver
        NotificationMailer.send_intercambio(email, d.id, d.RUTRecep, "inter_doc-signed#{t}.xml" ).deliver
        system("rm inter_tosign_xml#{t}.xml") 
        #system("rm doc-signed#{t}.xml")
        system("mv inter_doc-signed#{t}.xml public/uploads/documento/fileIntercambio/")
        d.estado = "APROBADO"
        d.save
    end

    @doccompras = Doccompra.where(estado: nil).where(:RUTRecep => Usuarioempresa.where(useremail:current_user.email).map {|u| u.rutempresa}).paginate(:page => params[:page], :per_page => 15 )
    respond_to do |format|
        format.html { render action: 'index'}
    end  
end

  def sendxml
    doccompra = Doccompra.find(params[:id])
    send_data doccompra.xmlrecibido.force_encoding('iso-8859-1') , :filename => "xml#{doccompra.Folio}.xml"
  end  

  private
    def set_doccompra
      @doccompra = Doccompra.find(params[:id])
    end

    def doccompra_params
      params.require(:doccompra).permit(:TipoDTE, :Folio, :FchEmis, :IndNoRebaja, :TipoDespacho, :IndTraslado, :TpoImpresion, :IndServicio, :MntBruto, :FmaPago, :FchVenc, :RUTEmisor, :RznSoc, :GiroEmis, :Telefono, :CorreoEmisor, :Acteco, :CdgTraslado, :FolioAut, :FchAut, :Sucursal, :CdgSIISucur, :CodAdicSucur, :DirOrigen, :CmnaOrigen, :CiudadOrigen, :CdgVendedor, :IdAdicEmisor, :RUTMandante, :RUTRecep, :CdgIntRecep, :RznSocRecep, :NumId, :Nacionalidad, :IdAdicRecep, :GiroRecep, :Contacto, :CorreoRecep, :DirRecep, :CmnaRecep, :CiudadRecep, :DirPostal, :CmnaPostal, :CiudadPostal, :RUTSolicita, :Patente, :RUTTrans, :RUTChofer, :NombreChofer, :DirDest, :CmnaDest, :CiudadDest, :CodModVenta, :CodClauVenta, :TotClauVenta, :CodViaTransp, :NombreTransp, :RUTCiaTransp, :NomCiaTransp, :IdAdicTransp, :Booking, :Operador, :CodPtoEmbarque, :IdAdicPtoEmb, :CodPtoDesemb, :IdAdicPtoDesemb, :Tara, :CodUnidMedTara, :PesoBruto, :CodUnidPesoBruto, :PesoNeto, :CodUnidPesoNeto, :TotItems, :TotBultos, :TpoMoneda, :MntNeto, :MntExe, :MntBase, :MntMargenCom, :TasaIVA, :IVA, :IVAProp, :IVATerc, :IVANoRet, :CredEC, :GrntDep, :ValComNeto, :ValComExe, :ValComIVA, :MntTotal, :MontoNF, :xmlrecibido, :estado)
    end

end
