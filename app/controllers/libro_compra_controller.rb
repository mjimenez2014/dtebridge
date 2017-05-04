class LibroCompraController < ApplicationController
  def index
    @empresas = Empresa.where(rut: Usuarioempresa.where(useremail:current_user.email).map {|u| u.rutempresa}) 
  end

  def find
    @empresas = Empresa.where(rut: Usuarioempresa.where(useremail:current_user.email).map {|u| u.rutempresa})

    @rut = params[:empresa]
    mes = params[:Mes].gsub('-','/')
    @fecha = mes
    if params[:Mes] == ""
        mes = "0001/01"
        @fecha = ""
    end

    emp = Empresa.where(rut: @rut).first
    @empresa = emp.rznsocial


    desde = Date.strptime("#{mes}/01", "%Y/%m/%d")
    hasta = Date.strptime("#{mes}/#{desde.end_of_month.day}", "%Y/%m/%d")  
    
    #@empresas = Empresa.all
    @documentos =  Doccompra.select('"TipoDTE", sum("MntNeto") as mntneto,sum("MntExe") as mntexe, sum("IVA") as iva, sum("MntTotal") as mnttotal, count(*) as count').where('estado <> ? AND "TipoDTE" <> 52 and "RUTEmisor"=? and "FchEmis" >= ? AND "FchEmis" <= ?',"Rechazado SII",  @rut, desde, hasta ).group('"TipoDTE"')
    totFact = Doccompra.select('sum("MntNeto") as mntneto,sum("MntExe") as mntexe, sum("IVA") as iva, sum("MntTotal") as mnttotal, count(*) as count').where('estado <> ? AND "TipoDTE" <> 52 and "TipoDTE"<>61 and "RUTEmisor"=? and "FchEmis" >= ? AND "FchEmis" <= ?',"Rechazado SII",  @rut, desde, hasta )
    totCred = Doccompra.select('sum("MntNeto") as mntneto,sum("MntExe") as mntexe, sum("IVA") as iva, sum("MntTotal") as mnttotal, count(*) as count').where('estado <> ? AND "TipoDTE"=61 and "RUTEmisor"=? and "FchEmis" >= ? AND "FchEmis" <= ?',"Rechazado SII",  @rut, desde, hasta )
 
    totFact.map {|e| @totFact = e}
    totCred.map {|e| @totCred = e}


    @otrosImps = Doccompra.select('"TipoDTE","imptoretencompras"."TipoImp" as tipoimp, "imptoretencompras"."TasaImp" as tasaimp, sum("imptoretencompras"."MontoImp") as montoimp').where('estado <> ? AND  "TipoDTE" <> 52 and "TipoDTE"<>61 and "RUTEmisor"=? and "FchEmis" >= ? AND "FchEmis" <= ?',"Rechazado SII",  @rut, desde, hasta ).joins(:imptoretencompras).group('"TipoDTE","imptoretencompras"."TipoImp","imptoretencompras"."TasaImp"')
    @otrosImpsCred = Doccompra.select('"TipoDTE","imptoretencompras"."TipoImp" as tipoimp, "imptoretencompras"."TasaImp" as tasaimp, sum("imptoretencompras"."MontoImp") as montoimp').where('estado <> ? AND  "TipoDTE"=61 and "RUTEmisor"=? and "FchEmis" > ? AND "FchEmis" < ?',"Rechazado SII",  @rut, desde, hasta ).joins(:imptoretencompras).group('"TipoDTE","imptoretencompras"."TipoImp","imptoretencompras"."TasaImp"')


    @docmanuals = Compmanual.select('"tipodoc", sum("mntneto") as mntneto,sum("mntexe") as mntexe, sum("mntiva") as iva, sum("mnttotal") as mnttotal,  sum(impto10+impto18+impto25+impto30) as otrosimp, count(*) as count').where('"estado" = ? and "tipodoc" <> 52 and "rutrecep"=?', "PREVIO", @rut).group('"tipodoc"')
    totFman = Compmanual.select('sum("mntneto") as mntneto,sum("mntexe") as mntexe, sum("mntiva") as iva, sum("mnttotal") as mnttotal,sum(impto10+impto18+impto25+impto30) as otrosimp, count(*) as count').where('"estado" = ? and "tipodoc" <> 52 and "tipodoc"<>60 and "tipodoc"<>61 and "rutrecep"=?',"PREVIO", @rut)
    totCManual = Compmanual.select('sum("mntneto") as mntneto,sum("mntexe") as mntexe, sum("mntiva") as iva, sum("mnttotal") as mnttotal,sum(impto10+impto18+impto25+impto30) as otrosimp,  count(*) as count').where('"estado" = ? and ("tipodoc"=60 or "tipodoc"=61) and "rutrecep"=?',"PREVIO", @rut)

    totFman.map {|e| @totFmanual = e}
    totCManual.map {|e| @totCredManual  = e}

    @otrosImpsMan = Compmanual.select('"tipodoc","otrosimpcompmanuals"."TipoImp" as tipoimp, "otrosimpcompmanuals"."TasaImp" as tasaimp, sum("otrosimpcompmanuals"."MontoImp") as montoimp').where('"estado" = ? and "tipodoc" <> 52 and "tipodoc"<>60 and "rutrecep"=?', "PREVIO",@rut).joins(:otrosimpcompmanuals).group('"tipodoc","otrosimpcompmanuals"."TipoImp","otrosimpcompmanuals"."TasaImp"')
    @otrosImpsCredMan = Compmanual.select('"tipodoc","otrosimpcompmanuals"."TipoImp" as tipoimp, "otrosimpcompmanuals"."TasaImp" as tasaimp, sum("otrosimpcompmanuals"."MontoImp") as montoimp').where('"estado" = ? and "tipodoc" = 60 and "tipodoc"=61 and "rutrecep"=?',"PREVIO", @rut).joins(:otrosimpcompmanuals).group('"tipodoc","otrosimpcompmanuals"."TipoImp","otrosimpcompmanuals"."TasaImp"')
   

    respond_to do |format|
      format.html { render action: 'index' }
    end
  end

  def generalibro
    @msg = "Se ha generado Libro"
    @rut = params[:rut]
    @mes = params[:mes]
    libro = Libro.where(rut: @rut).where(idenvio: @mes).where(tipo: "COMPRA").first

    unless libro.nil?
        if libro.enviado == "NO"
          libro.destroy
          if !create(@rut, @mes)
            @msg = "Libro NO generado" 
          end   
        else
            @msg = "Libro ya se ha generado y enviado a SII, no se puede volver a generar" 
        end
    else
        if !create(@rut, @mes)
            @msg = "Libro NO generado" 
        end    
    end
    respond_to do |format|
      format.html { render 'show' }  
    end  
  end

  def create (rut, mes)

    if (rut.nil? || mes.nil?)
        return false
    end    
     
    tipolibro = Compmanual.where('"rutrecep"=? and "estado" = ?',  rut, "PREVIO" ).last
     
    # registrar libro con sus datos
    libro = Libro.new
    libro.rut = rut
    libro.tipo = "COMPRA"
    libro.fecha = mes
    libro.estado = "XML NO Generado"
    libro.idenvio = mes.gsub('/','-')
    libro.enviado = "NO"
    libro.tipolibro = tipolibro.tipolibro
    libro.codautrec = tipolibro.codautrec
    libro.save

    desde = Date.strptime("#{mes}/01", "%Y/%m/%d")
    hasta = Date.strptime("#{mes}/#{desde.end_of_month.day}", "%Y/%m/%d")


    # llenar detalle libro con doc manuales
    docmanual = Compmanual.where('"rutrecep"=? and "estado" = ?',  rut, "PREVIO" )
    docmanual.map { |e|  
      detlibro = Detlibro.new
      detlibro.tipodte = e.tipodoc
      detlibro.rutemis = e.rutemisor
      detlibro.rutrecep = e.rutrecep
      detlibro.folio = e.folio
      detlibro.mnttotal = e.mnttotal
      detlibro.mntneto = e.mntneto
      detlibro.mntexe = e.mntexe
      detlibro.mntiva = e.mntiva
      detlibro.otrosimpto = e.otrosimpto
      detlibro.impto18 = e.impto18
      detlibro.impto10 = e.impto10
      detlibro.impto25 = e.impto25
      detlibro.impto30 = e.impto30
      detlibro.codimp = e.codimp
      detlibro.tasaimp = e.tasaimp
      detlibro.mntimp = e.mntimp
      detlibro.mntsincred = e.mntsincred
      detlibro.save
      
      if  e.otrosimpcompmanuals.present?
        e.otrosimpcompmanuals.each do |otroimp|
          imptoH = Hash.new 
          imptoH["TipoImp"] = otroimp.TipoImp  
          imptoH["TasaImp"] = otroimp.TasaImp
          imptoH["MontoImp"] = otroimp.MontoImp
          imptoH["detlibro_id"] =  detlibro.id
          imptoH["libro_id"] =  libro.id 
          imptoH["tipodte"] =  detlibro.tipodte                   
          Otrosimpdetlibro.create! imptoH  
        end
      end

      if e.ivanorec.present?
        detlibro.ivanorec = e.ivanorec
        detlibro.codivanorec = e.codivanorec
      else  
        detlibro.ivanorec = 0
        detlibro.codivanorec = 0
      end 


      detlibro.libro_id = libro.id 

      if detlibro.save
        e.estado = "EN LIBRO"
        e.save
      end
    }   

    return true 

  end


end
