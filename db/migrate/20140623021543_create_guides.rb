class CreateGuides < ActiveRecord::Migration
  def change
    create_table :guides do |t|
      t.integer :Version
      t.integer :TipoDTE
      t.integer :Folio
      t.date :FchEmis
      t.integer :TipoDespacho
      t.integer :IndTraslado
      t.string :TpoImpresion
      t.integer :FmaPago
      t.integer :FmaPagExp
      t.string :FchCancel
      t.integer :MntCancel
      t.integer :SaldoInsol
      t.string :FchPago
      t.integer :MntPago
      t.string :GlosaPagos
      t.string :TermPagoCdg
      t.string :TermPagoGlosa
      t.integer :TermPagoDias
      t.string :RUTEmisor
      t.string :RznSoc
      t.string :GiroEmis
      t.string :Telefono
      t.string :CorreoEmisor
      t.integer :Acteco
      t.integer :CdgTraslado
      t.integer :FolioAut
      t.date :FchAut
      t.string :Sucursal
      t.integer :CdgSIISucur
      t.string :DirOrigen
      t.string :CmnaOrigen
      t.string :CiudadOrigen
      t.string :CdgVendedor
      t.string :IdAdicEmisor
      t.string :RUTMandante
      t.string :RUTRecep
      t.string :CdgIntRecep
      t.string :RznSocRecep
      t.string :NumId
      t.string :Nacionalidad
      t.string :GiroRecep
      t.string :Contacto
      t.string :CorreoRecep
      t.string :DirRecep
      t.string :CmnaRecep
      t.string :CiudadRecep
      t.string :DirPostal
      t.string :CmnaPostal
      t.string :CiudadPostal
      t.string :Patente
      t.string :RUTTrans
      t.string :RUTChofer
      t.string :NombreChofer
      t.string :DirDest
      t.string :CmnaDest
      t.string :CiudadDest
      t.integer :CodModVenta
      t.integer :CodClauVenta
      t.integer :TotClauVenta
      t.integer :CodViaTransp
      t.string :NombreTransp
      t.string :RUTCiaTransp
      t.string :NomCiaTransp
      t.string :IdAdicTransp
      t.string :Booking
      t.string :Operador
      t.integer :CodPtoEmbarque
      t.string :IdAdicPtoEmb
      t.integer :CodPtoDesemb
      t.string :IdAdicPtoDesemb
      t.integer :Tara
      t.integer :CodUnidMedTara
      t.integer :CodUnidPesoBruto
      t.integer :PesoBruto
      t.integer :PesoNeto
      t.integer :CodUnidPesoNeto
      t.integer :TotItems
      t.integer :TotBultos
      t.string :TipoBultos
      t.integer :CodTpoBultos
      t.integer :CantBultos
      t.string :Marcas
      t.string :IdContainer
      t.string :Sello
      t.string :EmisorSello
      t.string :MntFlete
      t.string :MntSeguro
      t.string :CodPaisRecep
      t.string :CodPaisDestin
      t.integer :MntNeto
      t.integer :MntExe
      t.integer :MntBase
      t.integer :MntMargenCom
      t.integer :TasaIVA
      t.float :IVA
      t.integer :IVAProp
      t.integer :IVATerc
      t.string :TipoImp
      t.integer :TasaImp
      t.integer :MontoImp
      t.integer :CredEC
      t.integer :MntTotal
      t.integer :MontoNF
      t.integer :MontoPeriodo
      t.integer :SaldoAnterior
      t.integer :VlrPagar
      t.string :TpoMoneda
      t.integer :TpoCambio
      t.integer :MntNetoOtrMnda
      t.integer :MntExeOtrMnda
      t.string :MntFaeCarneOtr
      t.integer :Mnda
      t.string :MntMargComOtr
      t.integer :Mnda
      t.integer :IVAOtrMnda
      t.string :TipoImpOtrMnda
      t.integer :TasaImpOtrMnda
      t.integer :VlrImpOtrMnda
      t.integer :MntTotOtrMnda
      t.string :NroSti
      t.string :integer
      t.string :GlosaSti
      t.string :text
      t.string :OrdenSti
      t.string :integer
      t.string :SubTotNetoSti
      t.string :float
      t.string :SubTotIVASti
      t.string :float
      t.string :SubTotAdicSti
      t.string :float
      t.string :SubTotExeSti
      t.string :float
      t.string :ValSubTotSti
      t.string :float
      t.string :LineasDeta
      t.string :integer
      t.integer :NroLinDr
      t.string :TpoMov
      t.string :GlosaDr
      t.string :TpoValor
      t.float :ValorDr
      t.float :ValorDrOtrMnda
      t.integer :IndExeDr
      t.integer :NroLinRef
      t.string :TpoDocRef
      t.integer :IndGlobal
      t.string :FolioRef
      t.date :FchRef
      t.integer :CodRef
      t.string :RazonRef
      t.text :X509Certificate
      t.string :SignatureValue
      t.date :Tmstfirma

      t.timestamps
    end
  end
end
