# encoding: ISO-8859-1
class Api::V1::ReadmailController < Api::V1::ApiController
  def read_mail
    require 'mail'
    
    Mail.defaults do
      retriever_method :pop3, :address => "mail.invoicedigital.cl",
      :port       => 110,
      :user_name  => 'intercambioalmacenolga@invoicedigital.cl',
      :password   => 'almacenolga2016',
      :enable_ssl => false
    end

    #mails = Mail.all
    mails = Mail.find(:what => :last, :count => 2, :order => :asc)

    mails.each do |mail|
      doceamil = Docsemail.where(mailid: mail.message_id).first
      if !doceamil.present?
        if mail.multipart?  
          mail.attachments.each do | attachment |
            filename = attachment.filename
            puts "=============== FROM: ===================="
            puts mail.from
            extencion = filename[filename.index('.')..filename.index('.')+4]
            if extencion == ".xml"
              d = Docsemail.new
              d.xmlrecibido = attachment.body.decoded
              d.mailid = mail.message_id
              d.estado = "RECIBIDO"
              d.save
            end
          end
        end     
      end
    end  
    render json: "Ok"  
  end
end