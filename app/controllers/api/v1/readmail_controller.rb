# encoding: ISO-8859-1
class Api::V1::ReadmailController < Api::V1::ApiController
  def read_mail
    require 'mail'
    
    Mail.defaults do
      retriever_method :imap, :address => "mail.elsultan.cl",
      :port       => 143,
      :user_name  => 'intercambiochiquita@invoicedigital.cl',
      :password   => 'chiquita2016',
      :enable_ssl => false
    end

    mails = Mail.find(:count => 50,keys: ['NOT','SEEN'])

    mails.each do |mail|
      doceamil = Docsemail.where(mailid: mail.message_id).first
      if !doceamil.present?
        if mail.multipart?  
          mail.attachments.each do | attachment |
            filename = attachment.filename
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