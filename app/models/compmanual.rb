# encoding: ISO-8859-1
class Compmanual < ActiveRecord::Base
  require 'csv'

  has_many :otrosimpcompmanuals, dependent: :destroy

  def nomtipo
    Tipodte.find_by_tipo(self.tipodoc).nombre
  end

  def self.import(file)
    fileOk = false
    msg=" "
    begin
      CSV.foreach(file.path, col_sep: ';', headers: true, encoding: "ISO-8859-1" ) do |row|
        rowHash = row.to_hash
       
        if rowHash["fchemis"][0..3].index("-") != nil || rowHash["fchemis"].index("/") != nil
          msg = msg + "Documento folio " + rowHash["folio"] +", formato fecha incorrecto, debe ser : aaaa-mm-dd \r\n"
        end  

        if rowHash["ivanorec"] == 0 
          montotot = rowHash["mntneto"].to_f + rowHash["mntexe"].to_f + rowHash["mntiva"].to_f + rowHash["otrosimpto"].to_f + rowHash["impto18"].to_f + rowHash["impto10"].to_f + rowHash["impto25"].to_f + rowHash["impto30"].to_f
          if montotot != rowHash["mnttotal"].to_f 
            msg =  msg + "Documento folio " + rowHash["folio"] + " montos no cuadran.  \r\n" 
          end

          if (rowHash["mntneto"].to_f*0.19).round(0) != rowHash["mntiva"].to_f.round(0)
            msg =  msg + "Documento folio " + rowHash["folio"] + ", monto Iva no cuadra.  \r\n"
          end
        end

        if msg != " "
          return msg
        else
          fileOk = true
        end    
      end
    rescue
      msg = msg + "Formato de archivo incorrecto, revise si contiene algún caracter especial."
      puts "****************"
      puts msg
      puts puts "Error #{$!}"
      puts "****************"  
      return msg    
    end  


    if fileOk
      CSV.foreach(file.path, col_sep: ';', headers: true, encoding: "ISO-8859-1" ) do |row|

        rowHash = row.to_hash    

        rowHash["rznsocemisor"] = rowHash["rznsocemisor"][0..49].gsub('&','')
        rowHash["rutemisor"] = rowHash["rutemisor"].gsub('.','')
        rowHash["rutemisor"] = rowHash["rutemisor"].gsub('k','K')
        rowHash["rutrecep"] = rowHash["rutrecep"].gsub('.','')
        rowHash["rutrecep"] = rowHash["rutrecep"].gsub('k','K')

        if rowHash["impto10"]==nil
          rowHash["impto10"]="0"
        end  

        if rowHash["impto18"]==nil
          rowHash["impto18"]="0"
        end  

        if rowHash["impto25"]==nil
          rowHash["impto25"]="0"
        end  

        if rowHash["impto30"]==nil
          rowHash["impto30"]="0"
        end  

        if rowHash["mntneto"]==nil
          rowHash["mntneto"]="0"
        end 

        if rowHash["mntexe"]==nil
          rowHash["mntexe"]="0"
        end 

        if rowHash["mntiva"]==nil
          rowHash["mntiva"]="0"
        end 

        if rowHash["otrosimpto"]==nil
          rowHash["otrosimpto"]="0"
        end 


        doc = Compmanual.new(rowHash)

        if doc.rutrecep.index('-').nil?  
          doc.rutrecep = doc.rutrecep.insert(8, '-') 
        end  
        if doc.tipodoc == 1
          doc.tipodoc = 30
        end
        if doc.tipodoc == 7
          doc.tipodoc = 35
        end  
        doc.save

        impto10 = rowHash["impto10"].to_f
        impto18 = rowHash["impto18"].to_f
        impto25 = rowHash["impto25"].to_f
        impto30 = rowHash["impto30"].to_f

        if impto10>0
          imptoH = Hash.new 
          imptoH["TipoImp"] = 10   
          imptoH["TasaImp"] = 10 
          imptoH["MontoImp"] = impto10 
          imptoH["compmanual_id"] = doc.id
          Otrosimpcompmanual.create! imptoH
        end  
        if impto18>0
          imptoH = Hash.new 
          imptoH["TipoImp"] = 18   
          imptoH["TasaImp"] = 18 
          imptoH["MontoImp"] =impto18 
          imptoH["compmanual_id"] =doc.id
          Otrosimpcompmanual.create! imptoH
        end  
        if impto25>0
          imptoH = Hash.new 
          imptoH["TipoImp"] = 25   
          imptoH["TasaImp"] = 25 
          imptoH["MontoImp"] = impto25 
          imptoH["compmanual_id"] = doc.id
          Otrosimpcompmanual.create! imptoH
        end  
        if impto30>0
          imptoH = Hash.new 
          imptoH["TipoImp"] = 30   
          imptoH["TasaImp"] = 30 
          imptoH["MontoImp"] = impto30 
          imptoH["compmanual_id"] = doc.id
          Otrosimpcompmanual.create! imptoH
        end  
        doc.otrosimpto = impto10 + impto18 + impto25 + impto30
        doc.save
      end  
    end
    return msg
  end  
  
  def self.import2(file)
    fileOk = false
    msg=" "
    begin
      CSV.foreach(file.path, col_sep: ';', headers: true, encoding: "ISO-8859-1" ) do |row|
        rowHash = row.to_hash
       
        if rowHash["fchemis"][0..3].index("-") != nil || rowHash["fchemis"].index("/") != nil
          msg = msg + "Documento folio " + rowHash["folio"] +", formato fecha incorrecto, debe ser : aaaa-mm-dd \r\n"
        end  

        if rowHash["ivanorec"] == 0 
          montotot = rowHash["mntneto"].to_f + rowHash["mntexe"].to_f + rowHash["mntiva"].to_f + rowHash["otrosimpto"].to_f + rowHash["codimp"] + rowHash["tasaimmp"].to_f + rowHash["mntimp"]
          if montotot != rowHash["mnttotal"].to_f 
            msg =  msg + "Documento folio " + rowHash["folio"] + " montos no cuadran.  \r\n" 
          end

          if (rowHash["mntneto"].to_f*0.19).round(0) != rowHash["mntiva"].to_f.round(0)
            msg =  msg + "Documento folio " + rowHash["folio"] + ", monto Iva no cuadra.  \r\n"
          end
        end

        if msg != " "
          return msg
        else
          fileOk = true
        end    
      end
    rescue
      msg = msg + "Formato de archivo incorrecto, revise si contiene algún caracter especial."
      puts "****************"
      puts msg
      puts puts "Error #{$!}"
      puts "****************"  
      return msg    
    end  


    if fileOk
      CSV.foreach(file.path, col_sep: ';', headers: true, encoding: "ISO-8859-1" ) do |row|

        rowHash = row.to_hash    

        rowHash["rznsocemisor"] = rowHash["rznsocemisor"][0..49].gsub('&','')
        rowHash["rutemisor"] = rowHash["rutemisor"].gsub('.','')
        rowHash["rutemisor"] = rowHash["rutemisor"].gsub('k','K')
        rowHash["rutrecep"] = rowHash["rutrecep"].gsub('.','')
        rowHash["rutrecep"] = rowHash["rutrecep"].gsub('k','K')



        if rowHash["codimp"]==nil
          rowHash["codimp"]="0"
        end  

        if rowHash["tasaimp"]==nil
          rowHash["tasaimp"]="0"
        end  

        if rowHash["mntimp"]==nil
          rowHash["mntimp"]="0"
        end  

        if rowHash["mntneto"]==nil
          rowHash["mntneto"]="0"
        end 

        if rowHash["mntexe"]==nil
          rowHash["mntexe"]="0"
        end 

        if rowHash["mntiva"]==nil
          rowHash["mntiva"]="0"
        end 

        if rowHash["otrosimpto"]==nil
          rowHash["otrosimpto"]="0"
        end 


        doc = Compmanual.new(rowHash)

        if doc.rutrecep.index('-').nil?  
          doc.rutrecep = doc.rutrecep.insert(8, '-') 
        end  
        if doc.tipodoc == 1
          doc.tipodoc = 30
        end
        if doc.tipodoc == 7
          doc.tipodoc = 35
        end  
        doc.save

        impto18 = rowHash["codimp"].to_f
        impto25 = rowHash["tasaimp"].to_f
        impto30 = rowHash["mntimp"].to_f

        if impto10>0
          imptoH = Hash.new 
          imptoH["TipoImp"] = impto18   
          imptoH["TasaImp"] = impto25 
          imptoH["MontoImp"] = impto30 
          imptoH["compmanual_id"] = doc.id
          Otrosimpcompmanual.create! imptoH
        end  
 
        doc.otrosimpto = impto30
        doc.save
      end  
    end
    return msg
  end 

  def self.open_spreadsheet(file)

    # puts "*******************"
    # puts file.original_filename
    # puts "*******************"

    # case File.extname(file.original_filename)
    # when '.csv' then Csv.new(file.path, nil, :ignore)
    # when '.xls' then Roo::Excel.new(file.path)
    # when '.xlsx' then Roo::Excelx.new(file.path)
    # else raise "Unknown file type: #{file.original_filename}"
    # end
  end

end
