class Libro < ActiveRecord::Base
  has_many :detlibro, dependent: :destroy

  # searchable do
  #   text :empresa, :tipo, :fecha
  # end

  def empresa
      Empresa.find_by_rut(self.rut).rznsocial
  end

  def xml

    if self.tipo == "VENTA"
      libroventa  
    elsif self.tipo == "COMPRA"
      librocompratest
    end      

  end

  def libroventa

    libro = self
    empresa = Empresa.find_by_rut(libro.rut)
    numResolucion = empresa.numerores
    fchResolucion = empresa.fechares
    rutEnvia = empresa.rutenvia

    tosign_xml="<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>"
    tosign_xml+="<LibroCompraVenta xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:schemaLocation=\"http://www.sii.cl/SiiDte LibroCV_v10.xsd\" version=\"1.0\" xmlns=\"http://www.sii.cl/SiiDte\">"
    tosign_xml+="<EnvioLibro ID=\"IDV#{libro.idenvio}\">"
    tosign_xml+="<Caratula>"
    tosign_xml+="<RutEmisorLibro>#{libro.rut}</RutEmisorLibro>"

    tosign_xml+="<RutEnvia>#{rutEnvia}</RutEnvia>"
    tosign_xml+="<PeriodoTributario>#{libro.idenvio}</PeriodoTributario>"
    
    tosign_xml+="<FchResol>#{fchResolucion}</FchResol>"
    tosign_xml+="<NroResol>#{numResolucion}</NroResol>"

     tosign_xml+="<TipoOperacion>VENTA</TipoOperacion>"
    # Para certificacion
     # tosign_xml+="<TipoLibro>ESPECIAL</TipoLibro>"

    tosign_xml+="<TipoLibro>#{libro.tipolibro}</TipoLibro>"
    tosign_xml+="<TipoEnvio>TOTAL</TipoEnvio>"
    if(libro.tipolibro == "RECTIFICA")
      tosign_xml+="<CodAutRec>#{libro.codautrec}</CodAutRec>\r\n"
    end  
    # Solo para certificación 
     # tosign_xml+="<FolioNotificacion>1</FolioNotificacion>" 
    tosign_xml+="</Caratula>"

    #Resumen
    tipos = Tipodte.all

    tosign_xml+="<ResumenPeriodo>\r\n"

    #Documentos electronicos
    tipos.each do | t |

      cantidad = libro.detlibro.where(tipodte: t.tipo).count
      if t.tipo == 35
        cantidad = libro.detlibro.where(tipodte: t.tipo).sum(:cantidad)
      end

      if t.tipo == 48
        cantidad = libro.detlibro.where(tipodte: t.tipo).sum(:cantidad)
      end

      mntexe = libro.detlibro.where(tipodte: t.tipo).sum(:mntexe)
      mntneto = libro.detlibro.where(tipodte: t.tipo).sum(:mntneto)
      iva = libro.detlibro.where(tipodte: t.tipo).sum(:mntiva).to_i 
      mnttotal = libro.detlibro.where(tipodte: t.tipo).sum(:mnttotal).to_i

      impto18 = libro.detlibro.where(tipodte: t.tipo).sum(:impto18).to_i
      impto10 = libro.detlibro.where(tipodte: t.tipo).sum(:impto10).to_i
      impto25 = libro.detlibro.where(tipodte: t.tipo).sum(:impto25).to_i
      impto30 = libro.detlibro.where(tipodte: t.tipo).sum(:impto30).to_i

      if cantidad > 0 
        tosign_xml+="<TotalesPeriodo>\r\n"
        tosign_xml+="<TpoDoc>#{t.tipo}</TpoDoc>\r\n"
        tosign_xml+="<TotDoc>#{cantidad}</TotDoc>"
        tosign_xml+="<TotMntExe>#{mntexe}</TotMntExe>\r\n"
        tosign_xml+="<TotMntNeto>#{mntneto}</TotMntNeto>\r\n"
        tosign_xml+="<TotMntIVA>#{iva}</TotMntIVA>"

        if impto18 > 0
          tosign_xml+="<TotOtrosImp>\r\n"
          tosign_xml+="<CodImp>271</CodImp>\r\n"
          tosign_xml+="<TotMntImp>#{impto18}</TotMntImp>\r\n"
          tosign_xml+="</TotOtrosImp>\r\n"
        end
        if impto10 > 0
          tosign_xml+="<TotOtrosImp>\r\n"
          tosign_xml+="<CodImp>27</CodImp>\r\n"
          tosign_xml+="<TotMntImp>#{impto10}</TotMntImp>\r\n"
          tosign_xml+="</TotOtrosImp>\r\n"
        end
        if impto25 > 0
          tosign_xml+="<TotOtrosImp>\r\n"
          tosign_xml+="<CodImp>25</CodImp>\r\n"
          tosign_xml+="<TotMntImp>#{impto25}</TotMntImp>\r\n"
          tosign_xml+="</TotOtrosImp>\r\n"
        end
        if impto30 > 0
          tosign_xml+="<TotOtrosImp>\r\n"
          tosign_xml+="<CodImp>24</CodImp>\r\n"
          tosign_xml+="<TotMntImp>#{impto24}</TotMntImp>\r\n"
          tosign_xml+="</TotOtrosImp>\r\n"
        end

        tosign_xml+="<TotMntTotal>#{mnttotal}</TotMntTotal>\r\n"

        tosign_xml+="</TotalesPeriodo>\r\n"
      end
    end
    #Documentos Manuales

    tosign_xml+="</ResumenPeriodo>\r\n"

    tiposmanuales = Tipodte.where(manual: "S")

    tiposmanuales.each do |t|
      #Detalle
      detlibro = libro.detlibro.where(tipodte: t.tipo)

      detlibro.each do |det| 

        doc = Docmanual.where(folio: det.folio).where(rutemisor: det.rutemis).last

        if doc.tipodoc != 35 &&  doc.tipodoc != 38
          tosign_xml+="<Detalle>\r\n"
          tosign_xml+="<TpoDoc>#{doc.tipodoc}</TpoDoc>\r\n"
          tosign_xml+="<NroDoc>#{doc.folio}</NroDoc>\r\n"
          if doc.anulado == "S"
            tosign_xml+="<Anulado>A</Anulado>\r\n"
          end

          if doc.anulado == "N"
            
            tosign_xml+="<TasaImp>19</TasaImp>\r\n"
            
            tosign_xml+="<FchDoc>#{doc.fchemis}</FchDoc>\r\n"
            tosign_xml+="<RUTDoc>#{doc.rutrecep}</RUTDoc>\r\n"
            tosign_xml+="<RznSoc>#{doc.rznsocrecep}</RznSoc>\r\n"

            if doc.mntexe > 0
              tosign_xml+="<MntExe>#{doc.mntexe}</MntExe>\r\n"
            end  
            
            tosign_xml+="<MntNeto>#{doc.mntneto}</MntNeto>\r\n"
            tosign_xml+="<MntIVA>#{doc.mntiva.to_i}</MntIVA>\r\n"
            if doc.impto18 > 0
              tosign_xml+="<OtrosImp>\r\n"
              tosign_xml+="<CodImp>271</CodImp>\r\n"
              tosign_xml+="<TasaImp>18</TasaImp>\r\n"
              tosign_xml+="<MntImp>#{doc.impto18.to_i}</MntImp>\r\n"
              tosign_xml+="</OtrosImp>\r\n"
            end
            if doc.impto10 > 0
              tosign_xml+="<OtrosImp>\r\n"
              tosign_xml+="<CodImp>27</CodImp>\r\n"
              tosign_xml+="<TasaImp>10</TasaImp>\r\n"
              tosign_xml+="<MntImp>#{doc.impto10.to_i}</MntImp>\r\n"
              tosign_xml+="</OtrosImp>\r\n"
            end
            if doc.impto25 > 0
              tosign_xml+="<OtrosImp>\r\n"
              tosign_xml+="<CodImp>25</CodImp>\r\n"
              tosign_xml+="<TasaImp>20.5</TasaImp>\r\n"
              tosign_xml+="<MntImp>#{doc.impto25.to_i}</MntImp>\r\n"
              tosign_xml+="</OtrosImp>\r\n"
            end
            if doc.impto30 > 0
              tosign_xml+="<OtrosImp>\r\n"
              tosign_xml+="<CodImp>24</CodImp>\r\n"
              tosign_xml+="<TasaImp>31.5</TasaImp>\r\n"
              tosign_xml+="<MntImp>#{doc.impto30.to_i}</MntImp>\r\n"
              tosign_xml+="</OtrosImp>\r\n"
            end
            tosign_xml+="<MntTotal>#{doc.mnttotal}</MntTotal>\r\n"
          end
          tosign_xml+="</Detalle>\r\n"
        end
      end
    end
    #Fin EnvioLibro
    fchfirma = Date.strptime("#{Date.today.year}/#{Date.today.month}/#{Date.today.day}", "%Y/%m/%d")
    tosign_xml+="<TmstFirma>#{fchfirma}T15:26:15</TmstFirma>"
    tosign_xml+="</EnvioLibro>"

    #Firma
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
    tosign_xml+=   "</X509Data>"
    tosign_xml+=  "</KeyInfo>"
    tosign_xml+= "</Signature>"

    #Fin Libro  
    tosign_xml+= "</LibroCompraVenta>"

    
    File.open("libro_ventatosing#{libro.rut}#{libro.idenvio}.xml", 'w') { |file| file.puts tosign_xml}

    sleep 1
     
    if Empresa.last.rut == "80790400-0"
      puts "============"
      puts "ElSultan"
      puts "============"
      system("./comandoElSultan libro_ventatosing#{libro.rut}#{libro.idenvio}.xml libro_venta#{libro.rut}#{libro.idenvio}.xml")
    else  
      system("./comando libro_ventatosing#{libro.rut}#{libro.idenvio}.xml libro_venta#{libro.rut}#{libro.idenvio}.xml")
      puts "============"
      puts "Otros"
      puts "============"
    end  


   # lib = File.read "doc-signed#{t}.xml"

    system("rm libro_ventatosing#{libro.rut}#{libro.idenvio}.xml") 
  end

  def librocompra

    libro=self

    empresa = Empresa.find_by_rut(libro.rut)
    numResolucion = empresa.numerores
    fchResolucion = empresa.fechares
    rutEnvia = empresa.rutenvia

    tosign_xml="<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>"
    tosign_xml+="<LibroCompraVenta xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:schemaLocation=\"http://www.sii.cl/SiiDte LibroCV_v10.xsd\" version=\"1.0\" xmlns=\"http://www.sii.cl/SiiDte\">"
    tosign_xml+="<EnvioLibro ID=\"IDC#{libro.idenvio}\">\r\n"
    tosign_xml+=" <Caratula>\r\n"
    tosign_xml+=" <RutEmisorLibro>#{libro.rut}</RutEmisorLibro>\r\n"

    if Rails.env.production?
      tosign_xml+="   <RutEnvia>#{rutEnvia}</RutEnvia>\r\n"
      tosign_xml+="   <PeriodoTributario>#{libro.idenvio}</PeriodoTributario>\r\n"
      tosign_xml+="   <FchResol>#{fchResolucion}</FchResol>\r\n"
      tosign_xml+="   <NroResol>#{numResolucion}</NroResol>\r\n"
      tosign_xml+="   <TipoOperacion>COMPRA</TipoOperacion>\r\n"
      tosign_xml+="   <TipoLibro>MENSUAL</TipoLibro>\r\n"
      tosign_xml+="   <TipoEnvio>TOTAL</TipoEnvio>\r\n"
    else 
      tosign_xml+="   <RutEnvia>#{rutEnvia}</RutEnvia>\r\n"
      tosign_xml+="   <PeriodoTributario>#{libro.idenvio}</PeriodoTributario>\r\n"
      tosign_xml+="   <FchResol>2014-05-12</FchResol>\r\n"
      tosign_xml+="   <NroResol>0</NroResol>\r\n"
      tosign_xml+="   <TipoOperacion>COMPRA</TipoOperacion>\r\n"
      tosign_xml+="   <TipoLibro>ESPECIAL</TipoLibro>\r\n"
      tosign_xml+="   <TipoEnvio>TOTAL</TipoEnvio>\r\n"
      tosign_xml+="   <FolioNotificacion>2</FolioNotificacion>\r\n"
      if(libro.codautrec != "0")
      tosign_xml+="   <CodAutRec>#{libro.codautrec}</CodAutRec>\r\n"
      end  
    end

    tosign_xml+=" </Caratula>\r\n"

    tosign_xml+=" <ResumenPeriodo>\r\n"

    tipos = Tipodte.all # busco todos los tipos de documentos que existen
    tipos.each do | t | 
      cantidad = libro.detlibro.where(tipodte: t.tipo).count # cuenta los tipos de documentos del resumen
      mntexe = libro.detlibro.where(tipodte: t.tipo).sum(:mntexe)
      mntneto = libro.detlibro.where(tipodte: t.tipo).sum(:mntneto)
      iva = libro.detlibro.where(tipodte: t.tipo).sum(:mntiva).to_i 
      mnttotal = libro.detlibro.where(tipodte: t.tipo).sum(:mnttotal).to_i 

      impto18 = libro.detlibro.where(tipodte: t.tipo).where(:codimp =>271).sum(:mntimp).to_i
      impto10 = libro.detlibro.where(tipodte: t.tipo).sum(:impto10).to_i
      impto25 = libro.detlibro.where(tipodte: t.tipo).sum(:impto25).to_i
      impto30 = libro.detlibro.where(tipodte: t.tipo).sum(:impto30).to_i
      impto5 = libro.detlibro.where(tipodte: t.tipo).where(:codimp => 18).sum(:mntimp).to_i
      impto15 = libro.detlibro.where(tipodte: t.tipo).where(:codimp => 23).sum(:mntimp).to_i
      impto10 = libro.detlibro.where(tipodte: t.tipo).where(:codimp => 27).sum(:mntimp).to_i            
      impto12 = libro.detlibro.where(tipodte: t.tipo).where(:codimp => 19).sum(:mntimp).to_i
      impto20_5 = libro.detlibro.where(tipodte: t.tipo).where(:codimp => 25).sum(:mntimp).to_i
      impto20_5_2 = libro.detlibro.where(tipodte: t.tipo).where(:codimp => 26).sum(:mntimp).to_i
      diesel = libro.detlibro.where(tipodte: t.tipo).where(:codimp => 28).sum(:mntimp).to_i


      ivanorec = libro.detlibro.where(tipodte:t.tipo).sum(:ivanorec).to_i
      countivanorec = libro.detlibro.where(tipodte:t.tipo).where("codivanorec > ?", 0).count


      if cantidad > 0
        tosign_xml+="   <TotalesPeriodo>\r\n"
        tosign_xml+="     <TpoDoc>#{t.tipo}</TpoDoc>\r\n"
        tosign_xml+="     <TotDoc>#{cantidad}</TotDoc>\r\n"
        tosign_xml+="     <TotMntExe>#{mntexe}</TotMntExe>\r\n"
        tosign_xml+="     <TotMntNeto>#{mntneto}</TotMntNeto>\r\n"
        tosign_xml+="     <TotMntIVA>#{iva}</TotMntIVA>\r\n"
        
        if ivanorec > 0
          civanorec = libro.detlibro.where(tipodte:t.tipo).where("codivanorec > ?", 0).last
          codivanorec = civanorec.codivanorec
          tosign_xml+="   <TotIVANoRec>\r\n"
          tosign_xml+="   <CodIVANoRec>#{codivanorec}</CodIVANoRec>\r\n"
          tosign_xml+="   <TotOpIVANoRec>#{countivanorec}</TotOpIVANoRec>\r\n"
          tosign_xml+="   <TotMntIVANoRec>#{ivanorec}</TotMntIVANoRec>\r\n"
          tosign_xml+="   </TotIVANoRec>\r\n"
        end
        
        if impto5 > 0
          tosign_xml+="   <TotOtrosImp>\r\n"
          tosign_xml+="   <CodImp>18</CodImp>\r\n"
          tosign_xml+="   <TotMntImp>#{impto5}</TotMntImp>\r\n"
          tosign_xml+="   </TotOtrosImp>\r\n"
        end
        if impto15 > 0
          tosign_xml+="   <TotOtrosImp>\r\n"
          tosign_xml+="   <CodImp>23</CodImp>\r\n"
          tosign_xml+="   <TotMntImp>#{impto15}</TotMntImp>\r\n"
          tosign_xml+="   </TotOtrosImp>\r\n"
        end
        if impto10 > 0
          tosign_xml+="   <TotOtrosImp>\r\n"
          tosign_xml+="   <CodImp>27</CodImp>\r\n"
          tosign_xml+="   <TotMntImp>#{impto10}</TotMntImp>\r\n"
          tosign_xml+="   </TotOtrosImp>\r\n"
        end
        if impto12 > 0
          tosign_xml+="   <TotOtrosImp>\r\n"
          tosign_xml+="   <CodImp>19</CodImp>\r\n"
          tosign_xml+="   <TotMntImp>#{impto12}</TotMntImp>\r\n"
          tosign_xml+="   </TotOtrosImp>\r\n"
        end
          if impto20_5 > 0
          tosign_xml+="   <TotOtrosImp>\r\n"
          tosign_xml+="   <CodImp>25</CodImp>\r\n"
          tosign_xml+="   <TotMntImp>#{impto20_5}</TotMntImp>\r\n"
          tosign_xml+="   </TotOtrosImp>\r\n"
        end
        if impto18 > 0
          tosign_xml+="   <TotOtrosImp>\r\n"
          tosign_xml+="   <CodImp>271</CodImp>\r\n"
          tosign_xml+="   <TotMntImp>#{impto18}</TotMntImp>\r\n"
          tosign_xml+="   </TotOtrosImp>\r\n"
        end
        if impto25 > 0
          tosign_xml+="   <TotOtrosImp>\r\n"
          tosign_xml+="   <CodImp>25</CodImp>\r\n"
          tosign_xml+="   <TotMntImp>#{impto25}</TotMntImp>\r\n"
          tosign_xml+="   </TotOtrosImp>\r\n"
        end
        if impto30 > 0
          tosign_xml+="   <TotOtrosImp>\r\n"
          tosign_xml+="   <CodImp>24</CodImp>\r\n"
          tosign_xml+="   <TotMntImp>#{impto30}</TotMntImp>\r\n"
          tosign_xml+="   </TotOtrosImp>\r\n"
        end
        if impto20_5_2 > 0
          tosign_xml+="   <TotOtrosImp>\r\n"
          tosign_xml+="   <CodImp>26</CodImp>\r\n"
          tosign_xml+="   <TotMntImp>#{impto20_5_2}</TotMntImp>\r\n"
          tosign_xml+="   </TotOtrosImp>\r\n"
        end
        if diesel > 0
          tosign_xml+="   <TotOtrosImp>\r\n"
          tosign_xml+="   <CodImp>28</CodImp>\r\n"
          tosign_xml+="   <TotMntImp>#{diesel}</TotMntImp>\r\n"
          tosign_xml+="   </TotOtrosImp>\r\n"
        end
        tosign_xml+="   <TotMntTotal>#{mnttotal}</TotMntTotal>\r\n"
        tosign_xml+="   </TotalesPeriodo>\r\n"
      end
    end

    tosign_xml+=" </ResumenPeriodo>\r\n"

    #TO DO: Corrigir para usar modelo Doccompra
    tiposmanuales = Tipodte.all

    tiposmanuales.each do |t|
      #Detalle
      detlibro = libro.detlibro.where(tipodte: t.tipo)

      detlibro.each do |det| 

        doc = Compmanual.where(folio: det.folio).where(rutrecep: det.rutrecep).where(rutemisor: det.rutemis).last

        tosign_xml+="<Detalle>\r\n"
        tosign_xml+="<TpoDoc>#{det.tipodte}</TpoDoc>\r\n"
        tosign_xml+="<NroDoc>#{det.folio}</NroDoc>\r\n"
        tosign_xml+="<TpoImp>1</TpoImp>\r\n"
        tosign_xml+="<TasaImp>19</TasaImp>\r\n"
        tosign_xml+="<FchDoc>#{doc.fchemis}</FchDoc>\r\n"
        tosign_xml+="<RUTDoc>#{doc.rutemisor}</RUTDoc>\r\n"
        tosign_xml+="<RznSoc>#{doc.rznsocemisor}</RznSoc>\r\n"
        tosign_xml+="<MntExe>#{det.mntexe}</MntExe>\r\n"
        tosign_xml+="<MntNeto>#{det.mntneto}</MntNeto>\r\n"
        tosign_xml+="<MntIVA>#{det.mntiva.to_i}</MntIVA>"
        if doc.codimp > 0  
        tosign_xml+="<OtrosImp>\r\n"
        tosign_xml+="<CodImp>#{doc.codimp}</CodImp>\r\n"
        tosign_xml+="<TasaImp>#{doc.tasaimp}</TasaImp>\r\n"
        tosign_xml+="<MntImp>#{doc.mntimp.to_i}</MntImp>\r\n"
        tosign_xml+="</OtrosImp>\r\n"
        end 
        if doc.impto18 > 0
          tosign_xml+="<OtrosImp>\r\n"
          tosign_xml+="<CodImp>271</CodImp>\r\n"
          tosign_xml+="<TasaImp>18</TasaImp>\r\n"
          tosign_xml+="<MntImp>#{doc.impto18.to_i}</MntImp>\r\n"
          tosign_xml+="</OtrosImp>\r\n"
        end
        if doc.impto10 > 0
          tosign_xml+="<OtrosImp>\r\n"
          tosign_xml+="<CodImp>27</CodImp>\r\n"
          tosign_xml+="<TasaImp>10</TasaImp>\r\n"
          tosign_xml+="<MntImp>#{doc.impto10.to_i}</MntImp>\r\n"
          tosign_xml+="</OtrosImp>\r\n"
        end
        if doc.impto25 > 0
          tosign_xml+="<OtrosImp>\r\n"
          tosign_xml+="<CodImp>25</CodImp>\r\n"
          tosign_xml+="<TasaImp>20.5</TasaImp>\r\n"
          tosign_xml+="<MntImp>#{doc.impto25.to_i}</MntImp>\r\n"
          tosign_xml+="</OtrosImp>\r\n"
        end
        if doc.impto30 > 0
          tosign_xml+="<OtrosImp>\r\n"
          tosign_xml+="<CodImp>24</CodImp>\r\n"
          tosign_xml+="<TasaImp>31.5</TasaImp>\r\n"
          tosign_xml+="<MntImp>#{doc.impto30.to_i}</MntImp>\r\n"
          tosign_xml+="</OtrosImp>\r\n"
        end

        if det.ivanorec > 0
          tosign_xml+="<IVANoRec>\r\n"
          tosign_xml+="<CodIVANoRec>#{det.codivanorec}</CodIVANoRec>\r\n"
          tosign_xml+="<MntIVANoRec>#{det.ivanorec}</MntIVANoRec>\r\n"
          tosign_xml+="</IVANoRec>\r\n"
        end

        tosign_xml+="<MntTotal>#{det.mnttotal}</MntTotal>\r\n"
        tosign_xml+="</Detalle>\r\n"
      end  
    end

    fchfirma = Date.strptime("#{Date.today.year}/#{Date.today.month}/#{Date.today.day}", "%Y/%m/%d")
    tosign_xml+="<TmstFirma>#{fchfirma}T15:26:15</TmstFirma>"

    tosign_xml+="</EnvioLibro>\r\n"

    #Firma
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
    tosign_xml+=   "</X509Data>"
    tosign_xml+=  "</KeyInfo>"
    tosign_xml+= "</Signature>"

    #Fin Libro  
    tosign_xml+= "</LibroCompraVenta>"

    File.open("libro_compratosing#{libro.rut}#{libro.idenvio}.xml", 'w') { |file| file.puts tosign_xml}

    sleep 1
     
    if Empresa.last.rut == "80790400-0"
      puts "============"
      puts "ElSultan"
      puts "============"
      system("./comandoElSultan libro_compratosing#{libro.rut}#{libro.idenvio}.xml libro_compra#{libro.rut}#{libro.idenvio}.xml")
    else  
      system("./comando libro_compratosing#{libro.rut}#{libro.idenvio}.xml libro_compra#{libro.rut}#{libro.idenvio}.xml")
      puts "============"
      puts "Otros"
      puts "============"
    end  

   # lib = File.read "doc-signed#{t}.xml"

    system("rm libro_compratosing#{libro.rut}#{libro.idenvio}.xml") 
  end  

  def librocompratest
    libro=self

    empresa = Empresa.find_by_rut(libro.rut)
    numResolucion = empresa.numerores
    fchResolucion = empresa.fechares
    rutEnvia = empresa.rutenvia

    tosign_xml="<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>"
    tosign_xml+="<LibroCompraVenta xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:schemaLocation=\"http://www.sii.cl/SiiDte LibroCV_v10.xsd\" version=\"1.0\" xmlns=\"http://www.sii.cl/SiiDte\">"
    tosign_xml+="<EnvioLibro ID=\"IDC#{libro.idenvio}\">\r\n"
    tosign_xml+=" <Caratula>\r\n"
    tosign_xml+=" <RutEmisorLibro>#{libro.rut}</RutEmisorLibro>\r\n"

    if Rails.env.production?
      tosign_xml+="   <RutEnvia>#{rutEnvia}</RutEnvia>\r\n"
      tosign_xml+="   <PeriodoTributario>#{libro.idenvio}</PeriodoTributario>\r\n"
      tosign_xml+="   <FchResol>#{fchResolucion}</FchResol>\r\n"
      tosign_xml+="   <NroResol>#{numResolucion}</NroResol>\r\n"
      tosign_xml+="   <TipoOperacion>COMPRA</TipoOperacion>\r\n"
      tosign_xml+="   <TipoLibro>#{libro.tipolibro}</TipoLibro>\r\n"
      tosign_xml+="   <TipoEnvio>TOTAL</TipoEnvio>\r\n"
      if(libro.codautrec != "0")
      tosign_xml+="   <CodAutRec>#{libro.codautrec}</CodAutRec>\r\n"
      end        
    else 
      tosign_xml+="   <RutEnvia>#{rutEnvia}</RutEnvia>\r\n"
      tosign_xml+="   <PeriodoTributario>#{libro.idenvio}</PeriodoTributario>\r\n"
      tosign_xml+="   <FchResol>#{fchResolucion}</FchResol>\r\n"
      tosign_xml+="   <NroResol>0</NroResol>\r\n"
      tosign_xml+="   <TipoOperacion>COMPRA</TipoOperacion>\r\n"
      tosign_xml+="   <TipoLibro>ESPECIAL</TipoLibro>\r\n"
      tosign_xml+="   <TipoEnvio>TOTAL</TipoEnvio>\r\n"
      tosign_xml+="   <FolioNotificacion>2</FolioNotificacion>\r\n"
      if(libro.codautrec != "0")
      tosign_xml+="   <CodAutRec>#{libro.codautrec}</CodAutRec>\r\n"
      end  
    end

    tosign_xml+=" </Caratula>\r\n"

    tosign_xml+=" <ResumenPeriodo>\r\n"

    tipos = Tipodte.all # busco todos los tipos de documentos que existen
    tipos.each do | t | 
      cantidad = libro.detlibro.where(tipodte: t.tipo).count # cuenta los tipos de documentos del resumen
      mntexe = libro.detlibro.where(tipodte: t.tipo).sum(:mntexe)
      mntneto = libro.detlibro.where(tipodte: t.tipo).sum(:mntneto)
      iva = libro.detlibro.where(tipodte: t.tipo).sum(:mntiva).to_i 
      mnttotal = libro.detlibro.where(tipodte: t.tipo).sum(:mnttotal) 

      ivanorec = libro.detlibro.where(tipodte:t.tipo).sum(:ivanorec).to_i
      countivanorec = libro.detlibro.where(tipodte:t.tipo).where("codivanorec > ?", 0).count


      if cantidad > 0
        tosign_xml+="   <TotalesPeriodo>\r\n"
        tosign_xml+="     <TpoDoc>#{t.tipo}</TpoDoc>\r\n"
        tosign_xml+="     <TotDoc>#{cantidad}</TotDoc>\r\n"
        tosign_xml+="     <TotMntExe>#{mntexe}</TotMntExe>\r\n"
        tosign_xml+="     <TotMntNeto>#{mntneto}</TotMntNeto>\r\n"
        tosign_xml+="     <TotMntIVA>#{iva}</TotMntIVA>\r\n"
        
        if ivanorec > 0
          civanorec = libro.detlibro.where(tipodte:t.tipo).where("codivanorec > ?", 0).last
          codivanorec = civanorec.codivanorec
          tosign_xml+="   <TotIVANoRec>\r\n"
          tosign_xml+="   <CodIVANoRec>#{codivanorec}</CodIVANoRec>\r\n"
          tosign_xml+="   <TotOpIVANoRec>#{countivanorec}</TotOpIVANoRec>\r\n"
          tosign_xml+="   <TotMntIVANoRec>#{ivanorec}</TotMntIVANoRec>\r\n"
          tosign_xml+="   </TotIVANoRec>\r\n"
        end
        #Sumar impuestos por documento
        imp = Impuesto.all  
        imp.each do |impto|
            totMontoImp = Otrosimpdetlibro.where(tipodte: t.tipo).where(libro_id: libro.id).where(TipoImp: impto.tipoimp.to_s).sum(:MontoImp)# todos los doc del mimso tipo
            puts "=============== TOTAL MONTO IMPUESTO ==========================="
            puts totMontoImp
          if totMontoImp != 0
            tosign_xml+="   <TotOtrosImp>\r\n"
            tosign_xml+="    <CodImp>#{impto.tipoimp}</CodImp>\r\n"
            tosign_xml+="    <TotMntImp>#{totMontoImp}</TotMntImp>\r\n"
            tosign_xml+="   </TotOtrosImp>\r\n"
          end
        end
        tosign_xml+="   <TotMntTotal>#{mnttotal}</TotMntTotal>\r\n"
        tosign_xml+="   </TotalesPeriodo>\r\n"
      end
    end

    tosign_xml+=" </ResumenPeriodo>\r\n"

    #TO DO: Corrigir para usar modelo Doccompra
    tiposmanuales = Tipodte.all

    tiposmanuales.each do |t|
      #Detalle
      detlibro = libro.detlibro.where(tipodte: t.tipo)

      detlibro.each do |det| 

        doc = Compmanual.where(folio: det.folio).where(rutrecep: det.rutrecep).where(rutemisor: det.rutemis).last

        tosign_xml+="<Detalle>\r\n"
        tosign_xml+=" <TpoDoc>#{det.tipodte}</TpoDoc>\r\n"
        tosign_xml+=" <NroDoc>#{det.folio}</NroDoc>\r\n"
        tosign_xml+=" <TpoImp>1</TpoImp>\r\n"
        tosign_xml+=" <TasaImp>19</TasaImp>\r\n"
        tosign_xml+=" <FchDoc>#{doc.fchemis}</FchDoc>\r\n"
        tosign_xml+=" <RUTDoc>#{doc.rutemisor}</RUTDoc>\r\n"
        tosign_xml+=" <RznSoc>#{doc.rznsocemisor}</RznSoc>\r\n"
        tosign_xml+=" <MntExe>#{det.mntexe}</MntExe>\r\n"
        tosign_xml+=" <MntNeto>#{det.mntneto}</MntNeto>\r\n"
        tosign_xml+=" <MntIVA>#{det.mntiva.to_i}</MntIVA>\r\n"

        if doc.codimp > 0
          detlibroimp = Detlibro.find(det.id)  
          detlibroimp.otrosimpdetlibro.each do |otrosimp|
           tosign_xml+=" <OtrosImp>\r\n"
           tosign_xml+="   <CodImp>#{otrosimp.TipoImp}</CodImp>\r\n"
           tosign_xml+="   <TasaImp>#{otrosimp.TasaImp}</TasaImp>\r\n"
           tosign_xml+="   <MntImp>#{otrosimp.MontoImp.to_i}</MntImp>\r\n"
           tosign_xml+=" </OtrosImp>\r\n"
          end 
        end

        if det.ivanorec > 0
          tosign_xml+="<IVANoRec>\r\n"
          tosign_xml+="<CodIVANoRec>#{det.codivanorec}</CodIVANoRec>\r\n"
          tosign_xml+="<MntIVANoRec>#{det.ivanorec}</MntIVANoRec>\r\n"
          tosign_xml+="</IVANoRec>\r\n"
        end

        tosign_xml+="<MntTotal>#{det.mnttotal}</MntTotal>\r\n"
        tosign_xml+="</Detalle>\r\n"
      end  
    end

    fchfirma = Date.strptime("#{Date.today.year}/#{Date.today.month}/#{Date.today.day}", "%Y/%m/%d")
    tosign_xml+="<TmstFirma>#{fchfirma}T15:26:15</TmstFirma>"

    tosign_xml+="</EnvioLibro>\r\n"

    #Firma
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
    tosign_xml+=   "</X509Data>"
    tosign_xml+=  "</KeyInfo>"
    tosign_xml+= "</Signature>"

    #Fin Libro  
    tosign_xml+= "</LibroCompraVenta>"

    File.open("libro_compratosing#{libro.rut}#{libro.idenvio}.xml", 'w') { |file| file.puts tosign_xml}

    sleep 1
     
    if Empresa.last.rut == "80790400-0"
      puts "============"
      puts "ElSultan"
      puts "============"
      system("./comandoElSultan libro_compratosing#{libro.rut}#{libro.idenvio}.xml libro_compra#{libro.rut}#{libro.idenvio}.xml")
    else  
      system("./comando libro_compratosing#{libro.rut}#{libro.idenvio}.xml libro_compra#{libro.rut}#{libro.idenvio}.xml")
      puts "============"
      puts "Otros"
      puts "============"
    end  

   # lib = File.read "doc-signed#{t}.xml"

    system("rm libro_compratosing#{libro.rut}#{libro.idenvio}.xml")     
  end

end
