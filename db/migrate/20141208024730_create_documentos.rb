class CreateDocumentos < ActiveRecord::Migration
  def change
    create_table :documentos do |t|
      t.integer :TipoDTE
      t.integer :Folio
      t.string :FchEmis
      t.integer :IndNoRebaja
      t.integer :TipoDespacho
      t.integer :IndTraslado
      t.string :TpoImpresion
      t.integer :IndServicio
      t.integer :MntBruto
      t.integer :FmaPago
      t.string :FchVenc
      t.string :RUTEmisor
      t.string :RznSoc
      t.string :GiroEmis
      t.string :Telefono
      t.string :CorreoEmisor
      t.integer :Acteco
      t.integer :CdgTraslado
      t.integer :FolioAut
      t.string :FchAut
      t.string :Sucursal
      t.integer :CdgSIISucur
      t.string :CodAdicSucur
      t.string :DirOrigen
      t.string :CmnaOrigen
      t.string :CiudadOrigen
      t.integer :CdgVendedor
      t.string :IdAdicEmisor
      t.string :RUTMandante
      t.string :RUTRecep
      t.string :CdgIntRecep
      t.string :RznSocRecep
      t.string :NumId
      t.string :Nacionalidad
      t.string :IdAdicRecep
      t.string :GiroRecep
      t.string :Contacto
      t.string :CorreoRecep
      t.string :DirRecep
      t.string :CmnaRecep
      t.string :CiudadRecep
      t.string :DirPostal
      t.string :CmnaPostal
      t.string :CiudadPostal
      t.string :RUTSolicita
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
      t.string :CodPtoDesemb
      t.string :IdAdicPtoDesemb
      t.integer :Tara
      t.integer :CodUnidMedTara
      t.integer :PesoBruto
      t.integer :CodUnidPesoBruto
      t.integer :PesoNeto
      t.integer :CodUnidPesoNeto
      t.integer :TotItems
      t.integer :TotBultos
      t.string :TpoMoneda
      t.integer :MntNeto
      t.integer :MntExe
      t.integer :MntBase
      t.integer :MntMargenCom
      t.float :TasaIVA
      t.integer :IVA
      t.integer :IVAProp
      t.integer :IVATerc
      t.integer :IVANoRet
      t.integer :CredEC
      t.integer :GrntDep
      t.integer :ValComNeto
      t.integer :ValComExe
      t.integer :ValComIVA
      t.integer :MntTotal
      t.integer :MontoNF

      t.timestamps
    end
  end
end