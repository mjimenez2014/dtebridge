## encoding: UTF-8
class NotificationMailer < ActionMailer::Base
  default from: "dte_santiago@lubba.cl"
 
  def notification_emails(email)
    @user = "user Osvaldo"
    @url  = 'http://www.invoicedigital.cl/page/index.html'
   # attachments['DTE_77888630-8_33_2001_20141213T204055CEDIBLE.pdf'] = File.read("#{Rails.root}/public/uploads/documento/pdfs/DTE_77888630-8_33_2001_20141213T204055CEDIBLE.pdf")
   # attachments['DTE_77888630-8_33_2001_20141213T204055.pdf'] = File.read("#{Rails.root}/public/uploads/documento/pdft/DTE_77888630-8_33_2001_20141213T204055.pdf")
   # attachments['EnvioUnit_77888630-8_2001_20141213T114725.xml'] = File.read("#{Rails.root}/public/uploads/documento/fileEnvio/EnvioUnit_77888630-8_2001_20141213T114725.xml").force_encoding('iso-8859-1').encode('utf-8')

    mail(to: email, subject: 'Notificación InvoiceDigital')
  end

  def notification_email(email,id)
    puts"==================== Enviando Correo ================================"
    doc = Documento.find(id)
    @user = doc.RznSocRecep
    @destinatario = doc.RznSocRecep
    @rut = doc.RUTEmisor
    @empresa = doc.RznSoc
    @documento = Tipodte.find_by_tipo(doc.TipoDTE).nombre
    @folio = doc.Folio 
    @url  = 'http://www.invoicedigital.cl'

    attachments["#{doc.Folio}_cliente.xml"] =  File.read("#{Rails.root}/public#{doc.fileCliente}").force_encoding('iso-8859-1').encode('utf-8')

    mail(to: email, subject: "DTE #{@folio} #{@empresa}", from:  Empresa.find_by_rut(doc.RUTEmisor).from)

    envio = Enviocliente.new
    envio.folio = @folio
    envio.rut = doc.RUTRecep
    envio.tipo = doc.TipoDTE
    envio.rznsoc = doc.RznSocRecep
    envio.save

  end

  def alert_iat_email(email, sucursal, empresa)
    @user = "Precioso"
    @url  = 'http://www.invoicedigital.cl'
    mail(to: email, subject: "IAT offline en sucursal : #{sucursal}, #{empresa}" )
  end

  def send_intercambio(email, id, empresa, docxml)
    doc = Doccompra.find(id)
    @user = doc.RznSocRecep
    @destinatario = doc.RznSoc
    @rut = doc.RUTEmisor
    @empresa = doc.RznSoc
    @documento = Tipodte.find_by_tipo(doc.TipoDTE).nombre
    @folio = doc.Folio 
    @user = "Precioso"
    @url  = 'http://www.invoicedigital.cl'
    attachments["inter_#{doc.Folio}_cliente.xml"] =  File.read("#{Rails.root}/#{docxml}").force_encoding('iso-8859-1').encode('utf-8')
    mail(to: email, subject: "Intercambio DTE, #{empresa}")
  end

end
