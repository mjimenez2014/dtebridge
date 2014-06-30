class Guide < ActiveRecord::Base
	validates :Version, length:{maximum: 3}, presence: true
	validates :TipoDte, length:{maximum: 2}, presence: true
	validates :Folio, length:{maximum: 10}, presence: true
	validates :FchEmis, length:{maximum: 10}, presence: true
	validates :TipoDespacho, length:{maximum: 1}
	validates :IndTraslado, length:{maximum: 1}, presence: true
	validates :TpoImpresion, length:{maximum: 1}
	validates :FmaPago, length:{maximum: 1}
	validates :FmaPagExp, length:{maximum: 2}
	validates :FchCancel, length:{maximum: 10}
	validates :MntCancel, length:{maximum: 18}
	validates :SaldoInsol, length:{maximum: 18}
	validates :FchPago, length:{maximum: 10}, presence: true
	validates :MntPago, length:{maximum: 18}, presence: true
	validates :GlosaPagos, length:{maximum: 40}
	validates :TermPagoCdg, length:{maximum: 4}
	validates :TermPAgoGlosa, length:{maximum: 100}
	validates :TermPagoDias, length:{maximum: 3}
	validates :RUTEmisor, length:{maximum: 10}, presence: true, rut_format: true
	validates :RznSoc, length:{maximum: 100}, presence: true
	validates :GiroEmis, length:{maximum: 80}, presence: true
	validates :Telefono, length:{maximum: 20}
	validates :CorreoEmisor, length:{maximum: 80}
	validates :Acteco, length:{maximum: 6}, presence: true
	validates :CdgTraslado, length:{maximum: 1}
	validates :FolioAut, length:{maximum: 5}
	validates :FchAut, length:{maximum: 10}
	validates :Sucursal, length:{maximum: 20}
	validates :CdgSIISucur, length:{maximum: 9}
	validates :DirOrigen, length:{maximum: 60}, presence: true
	validates :CmnaOrigen, length:{maximum: 20}, presence: true
	validates :CiudadOrigen, length:{maximum: 20}
	validates :CdgVendedor, length:{maximum: 60}
	validates :IdAdicEmisor, length:{maximum: 20}
	validates :RutMandante, length:{maximum: 10}
	validates :RUTReceptor, length:{maximum: 10}, presence: true
	validates :CdgIntRecep, length:{maximum: 20}
	validates :RznSocRecep, length:{maximum: 100}, presence: true
	validates :NumId, length:{maximum: 20}
	validates :Nacionalidad, length:{maximum: 3}
	validates :GiroRecep, length:{maximum: 40}, presence: true
	validates :Contacto, length:{maximum: 80}
	validates :CorreoRecep, length:{maximum: 80}
	validates :DirRecep, length:{maximum: 70}, presence: true
	validates :CmnaRecep, length:{maximum: 20}, presence: true
	validates :CiudadRecep, length:{maximum: 20}
	validates :DirPostal, length:{maximum: 70}
	validates :CmnaPostal, length:{maximum: 20}
	validates :CiudadPostal, length:{maximum: 20}
	validates :Patente, length:{maximum: 8}
	validates :RUTTRans, length:{maximum: 10}
	validates :RUTChofer, length:{maximum: 10}
	validates :NombreChofer, length:{maximum: 30}
	validates :DirDest, length:{maximum: 70}
	validates :CmnaDest, length:{maximum: 20}, presence: true
	validates :CiudadDest, length:{maximum: 20}
	validates :CodModVenta, length:{maximum: 2}
	validates :CodClauVenta, length:{maximum: 2}
	validates :TotClauVenta, length:{maximum: 18}
	validates :CodViaTransp, length:{maximum: 2}
	validates :NombreTransp, length:{maximum: 2}
	validates :RUTCiaTransp, length:{maximum: 10}
	validates :NomCiaTRansp, length:{maximum: 40}
	validates :IdAdicTransp, length:{maximum: 18}
	validates :Booking, length:{maximum: 20}
	validates :Operador, length:{maximum: 20}
	validates :CodPtoEmbarque, length:{maximum: 4}
	validates :IdAdicPtoEmb, length:{maximum: 20}
	validates :CodPtoDesemb, length:{maximum: 4}
	validates :IdAdicPtoDesemb, length:{maximum: 20}
	validates :Tara, length:{maximum: 7}
	validates :CodUnidMedTara, length:{maximum: 2}
	validates :PesoBruto, length:{maximum: 12}
	validates :CodUnidPesoBruto, length:{maximum: 2}
	validates :PesoNeto, length:{maximum: 12}
	validates :CodUnidPesoNeto, length:{maximum: 2}
	validates :TotItems, length:{maximum: 18}
	validates :TotBultos, length:{maximum: 18}
	validates :CodTpoBultos, length:{maximum: 3}
	validates :CantBultos, length:{maximum: 10}
	validates :Marcas, length:{maximum: 255}
	validates :IdContainer, length:{maximum: 25}
	validates :Sello, length:{maximum: 20}
	validates :EmisorSello, length:{maximum: 70}
	validates :MntFlete, length:{maximum: 18}
	validates :MntSeguro, length:{maximum: 18}
	validates :CodPaisRecep, length:{maximum: 3}
	validates :CodPaisDestin, length:{maximum: 3}
	validates :MntNeto, length:{maximum: 18}
	validates :MntExe, length:{maximum: 18}
	validates :MntBase, length:{maximum: 18}
	validates :MntMargenCom, length:{maximum: 18}
	validates :TasaIVA, length:{maximum: 5}
	validates :IVA, length:{maximum: 18}
	validates :IVAProp, length:{maximum: 18}
	validates :IVATerc, length:{maximum: 18}
	validates :TipoImp, length:{maximum: 3}
	validates :TasaImp, length:{maximum: 5}
	validates :MontoImp, length:{maximum: 18}
	validates :CredEC, length:{maximum: 18}
	validates :MntTotal, length:{maximum: 18}, presence: true
	validates :MontoNF, length:{maximum: 18}
	validates :MontoPeriodo, length:{maximum: 18}
	validates :SaldoAnterior, length:{maximum: 18}
	validates :VlrPagar, length:{maximum: 18}
	validates :TpoMoneda, length:{maximum: 15}
	validates :TpoCambio, length:{maximum: 10}
	validates :MntNetoOtrMnda, length:{maximum: 18}
	validates :MntExeOtrMnda, length:{maximum: 18}
	validates :MntFaeCarneOtrMnda, length:{maximum: 18}
	validates :MntMargComOtrMnda, length:{maximum: 18}
	validates :IVAOtrMnda, length:{maximum: 18}
	validates :TipoImpOtrMnda, length:{maximum: 3}
	validates :TasaImpOtrMnda, length:{maximum: 5}
	validates :VlrImpOtrMnda, length:{maximum: 18}
	validates :MntTotOtrMnda, length:{maximum: 18}
	validates :NroSti, length:{maximum: 2}, presence: true
	validates :GlosaSti, length:{maximum: 40}, presence: true
	validates :OrdenSti, length:{maximum: 2}
	validates :SubTotNetoSti, length:{maximum: 18}
	validates :SubTotIVASti, length:{maximum: 18}
	validates :SubTotAdicSti, length:{maximum: 18}
	validates :SubTotExeSti, length:{maximum: 18}
	validates :ValSubTotSti, length:{maximum: 18}
	validates :LineasDeta, length:{maximum: 18}
	validates :NroLinDr, length:{maximum: 2}, presence: true
	validates :TpoMov, length:{maximum: 1}, presence: true
	validates :GlosaDr, length:{maximum: 45}
	validates :TpoValor, length:{maximum: 1}, presence: true
	validates :ValorDr, length:{maximum: 18}, presence: true
	validates :ValorDrOtrMnda, length:{maximum: 18}
	validates :IndExeDr, length:{maximum: 1}
	validates :NroLinRef, length:{maximum: 2}, presence: true
	validates :TpoDocRef, length:{maximum: 3}, presence: true
	validates :FolioRef, length:{maximum: 18}, presence: true
	validates :FchRef, length:{maximum: 10}, presence: true
	validates :CodRef, length:{maximum: 1}
	validates :RazonRef,length:{maximum: 90}
	validates :X509Certificate, presence:true
	validates :Pdf, presence:true
	validates :Xml, presence:true

end