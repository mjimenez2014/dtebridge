# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20161022162408) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: true do |t|
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cdgitems", force: true do |t|
    t.string   "TpoCodigo"
    t.string   "VlrCodigo"
    t.integer  "detcompra_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cdgitems", ["detcompra_id"], name: "index_cdgitems_on_detcompra_id", using: :btree

  create_table "comisioncompras", force: true do |t|
    t.integer  "NroLinCom"
    t.string   "TipoMovim"
    t.string   "Glosa"
    t.integer  "ValComNeto"
    t.integer  "ValComExe"
    t.integer  "ValComIVA"
    t.integer  "doccompra_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comisioncompras", ["doccompra_id"], name: "index_comisioncompras_on_doccompra_id", using: :btree

  create_table "comisions", force: true do |t|
    t.integer  "NroLinCom"
    t.string   "TipoMovim"
    t.string   "Glosa"
    t.integer  "ValComNeto"
    t.integer  "ValComExe"
    t.integer  "ValComIVA"
    t.integer  "documento_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comisions", ["documento_id"], name: "index_comisions_on_documento_id", using: :btree

  create_table "compmanuals", force: true do |t|
    t.integer  "tipodoc"
    t.integer  "folio"
    t.string   "fchemis"
    t.string   "rutemisor"
    t.string   "rutrecep"
    t.string   "rznsocemisor"
    t.integer  "mntneto"
    t.integer  "mntexe"
    t.float    "mntiva"
    t.float    "otrosimpto"
    t.integer  "mnttotal"
    t.float    "impto18"
    t.float    "impto10"
    t.float    "impto25"
    t.float    "impto30"
    t.string   "estado"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "ivanorec"
    t.integer  "codivanorec"
    t.integer  "codimp"
    t.float    "tasaimp"
    t.integer  "mntimp"
    t.string   "tipolibro"
    t.string   "codautrec"
  end

  create_table "contribuyentes", force: true do |t|
    t.string   "rut"
    t.string   "nombre"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "detalles", force: true do |t|
    t.integer  "NroLinDet"
    t.string   "TpoCodigo"
    t.string   "VlrCodigo"
    t.string   "TpoDocLiq"
    t.string   "IndExe"
    t.string   "IndAgente"
    t.integer  "MntBaseFaena"
    t.integer  "MntMargComer"
    t.integer  "PrcConsFinal"
    t.integer  "NmbItem"
    t.text     "DscItem"
    t.integer  "QtyRef"
    t.string   "UnmdRef"
    t.float    "PrcRef"
    t.float    "QtyItem"
    t.string   "FchElabor"
    t.string   "FchVencim"
    t.string   "UnmdItem"
    t.float    "PrcItem"
    t.float    "DescuentoPct"
    t.integer  "DescuentoMonto"
    t.string   "CodImpAdic"
    t.integer  "MontoItem"
    t.integer  "documento_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "PrcBruItem"
    t.float    "DescuentoBruMonto"
    t.float    "MontoBruItem"
    t.string   "CodCatalog"
  end

  add_index "detalles", ["documento_id"], name: "index_detalles_on_documento_id", using: :btree

  create_table "detcompras", force: true do |t|
    t.integer  "NroLinDet"
    t.string   "TpoCodigo"
    t.string   "VlrCodigo"
    t.string   "TpoDocLiq"
    t.string   "IndExe"
    t.string   "IndAgente"
    t.float    "MntBaseFaena"
    t.float    "MntMargComer"
    t.integer  "PrcConsFinal"
    t.string   "NmbItem"
    t.string   "DscItem"
    t.float    "QtyRef"
    t.string   "UnmdRef"
    t.float    "PrcRef"
    t.float    "QtyItem"
    t.string   "FchElabor"
    t.string   "FchVencim"
    t.string   "UnmdItem"
    t.float    "PrcItem"
    t.float    "DescuentoPct"
    t.float    "DescuentoMonto"
    t.string   "CodImpAdic"
    t.float    "MontoItem"
    t.integer  "doccompra_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "TipoDscto"
    t.float    "ValorDscto"
  end

  add_index "detcompras", ["doccompra_id"], name: "index_detcompras_on_doccompra_id", using: :btree

  create_table "detlibros", force: true do |t|
    t.integer  "tipodte"
    t.integer  "folio"
    t.string   "rutemis"
    t.integer  "mnttotal"
    t.integer  "libro_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "mntneto"
    t.integer  "mntexe"
    t.float    "mntiva"
    t.float    "otrosimpto"
    t.float    "impto18"
    t.float    "impto10"
    t.float    "impto25"
    t.float    "impto30"
    t.string   "rutrecep"
    t.integer  "cantidad"
    t.integer  "ivanorec"
    t.integer  "codivanorec"
    t.integer  "codimp"
    t.float    "tasaimp"
    t.integer  "mntimp"
  end

  add_index "detlibros", ["libro_id"], name: "index_detlibros_on_libro_id", using: :btree

  create_table "doccompras", force: true do |t|
    t.integer  "TipoDTE"
    t.integer  "Folio"
    t.string   "FchEmis"
    t.integer  "IndNoRebaja"
    t.integer  "TipoDespacho"
    t.integer  "IndTraslado"
    t.string   "TpoImpresion"
    t.integer  "IndServicio"
    t.integer  "MntBruto"
    t.integer  "FmaPago"
    t.string   "FchVenc"
    t.string   "RUTEmisor"
    t.string   "RznSoc"
    t.string   "GiroEmis"
    t.string   "Telefono"
    t.string   "CorreoEmisor"
    t.integer  "Acteco"
    t.integer  "CdgTraslado"
    t.integer  "FolioAut"
    t.string   "FchAut"
    t.string   "Sucursal"
    t.integer  "CdgSIISucur"
    t.string   "CodAdicSucur"
    t.string   "DirOrigen"
    t.string   "CmnaOrigen"
    t.string   "CiudadOrigen"
    t.integer  "CdgVendedor"
    t.string   "IdAdicEmisor"
    t.string   "RUTMandante"
    t.string   "RUTRecep"
    t.string   "CdgIntRecep"
    t.string   "RznSocRecep"
    t.string   "NumId"
    t.string   "Nacionalidad"
    t.string   "IdAdicRecep"
    t.string   "GiroRecep"
    t.string   "Contacto"
    t.string   "CorreoRecep"
    t.string   "DirRecep"
    t.string   "CmnaRecep"
    t.string   "CiudadRecep"
    t.string   "DirPostal"
    t.string   "CmnaPostal"
    t.string   "CiudadPostal"
    t.string   "RUTSolicita"
    t.string   "Patente"
    t.string   "RUTTrans"
    t.string   "RUTChofer"
    t.string   "NombreChofer"
    t.string   "DirDest"
    t.string   "CmnaDest"
    t.string   "CiudadDest"
    t.integer  "CodModVenta"
    t.integer  "CodClauVenta"
    t.integer  "TotClauVenta"
    t.integer  "CodViaTransp"
    t.string   "NombreTransp"
    t.string   "RUTCiaTransp"
    t.string   "NomCiaTransp"
    t.string   "IdAdicTransp"
    t.string   "Booking"
    t.string   "Operador"
    t.integer  "CodPtoEmbarque"
    t.string   "IdAdicPtoEmb"
    t.string   "CodPtoDesemb"
    t.string   "IdAdicPtoDesemb"
    t.integer  "Tara"
    t.integer  "CodUnidMedTara"
    t.integer  "PesoBruto"
    t.integer  "CodUnidPesoBruto"
    t.integer  "PesoNeto"
    t.integer  "CodUnidPesoNeto"
    t.integer  "TotItems"
    t.integer  "TotBultos"
    t.string   "TpoMoneda"
    t.integer  "MntNeto"
    t.integer  "MntExe"
    t.integer  "MntBase"
    t.integer  "MntMargenCom"
    t.float    "TasaIVA"
    t.integer  "IVA"
    t.integer  "IVAProp"
    t.integer  "IVATerc"
    t.integer  "IVANoRet"
    t.integer  "CredEC"
    t.integer  "GrntDep"
    t.integer  "ValComNeto"
    t.integer  "ValComExe"
    t.integer  "ValComIVA"
    t.integer  "MntTotal"
    t.integer  "MontoNF"
    t.text     "xmlrecibido"
    t.string   "estado"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "VlrPagar"
  end

  add_index "doccompras", ["RUTEmisor", "Folio", "TipoDTE"], name: "index_doccompras_on_RUTEmisor_and_Folio_and_TipoDTE", unique: true, using: :btree

  create_table "docmanuals", force: true do |t|
    t.integer  "tipodoc"
    t.integer  "folio"
    t.string   "fchemis"
    t.string   "rutemisor"
    t.string   "rutrecep"
    t.string   "rznsocrecep"
    t.integer  "mntneto"
    t.integer  "mntexe"
    t.float    "mntiva"
    t.float    "otrosimpto"
    t.integer  "mnttotal"
    t.float    "impto18"
    t.float    "impto10"
    t.float    "impto25"
    t.float    "impto30"
    t.string   "estado"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "anulado"
    t.integer  "cantidad"
  end

  create_table "docsemails", force: true do |t|
    t.string   "estado"
    t.text     "xmlrecibido"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "mailid"
  end

  create_table "documentos", force: true do |t|
    t.integer  "TipoDTE"
    t.integer  "Folio"
    t.string   "FchEmis"
    t.integer  "IndNoRebaja"
    t.integer  "TipoDespacho"
    t.integer  "IndTraslado"
    t.string   "TpoImpresion"
    t.integer  "IndServicio"
    t.integer  "MntBruto"
    t.integer  "FmaPago"
    t.string   "FchVenc"
    t.string   "RUTEmisor"
    t.string   "RznSoc"
    t.string   "GiroEmis"
    t.string   "Telefono"
    t.string   "CorreoEmisor"
    t.integer  "Acteco"
    t.integer  "CdgTraslado"
    t.integer  "FolioAut"
    t.string   "FchAut"
    t.string   "Sucursal"
    t.integer  "CdgSIISucur"
    t.string   "CodAdicSucur"
    t.string   "DirOrigen"
    t.string   "CmnaOrigen"
    t.string   "CiudadOrigen"
    t.integer  "CdgVendedor"
    t.string   "IdAdicEmisor"
    t.string   "RUTMandante"
    t.string   "RUTRecep"
    t.string   "CdgIntRecep"
    t.string   "RznSocRecep"
    t.string   "NumId"
    t.string   "Nacionalidad"
    t.string   "IdAdicRecep"
    t.string   "GiroRecep"
    t.string   "Contacto"
    t.string   "CorreoRecep"
    t.string   "DirRecep"
    t.string   "CmnaRecep"
    t.string   "CiudadRecep"
    t.string   "DirPostal"
    t.string   "CmnaPostal"
    t.string   "CiudadPostal"
    t.string   "RUTSolicita"
    t.string   "Patente"
    t.string   "RUTTrans"
    t.string   "RUTChofer"
    t.string   "NombreChofer"
    t.string   "DirDest"
    t.string   "CmnaDest"
    t.string   "CiudadDest"
    t.integer  "CodModVenta"
    t.integer  "CodClauVenta"
    t.integer  "TotClauVenta"
    t.integer  "CodViaTransp"
    t.string   "NombreTransp"
    t.string   "RUTCiaTransp"
    t.string   "NomCiaTransp"
    t.string   "IdAdicTransp"
    t.string   "Booking"
    t.string   "Operador"
    t.integer  "CodPtoEmbarque"
    t.string   "IdAdicPtoEmb"
    t.string   "CodPtoDesemb"
    t.string   "IdAdicPtoDesemb"
    t.integer  "Tara"
    t.integer  "CodUnidMedTara"
    t.integer  "PesoBruto"
    t.integer  "CodUnidPesoBruto"
    t.integer  "PesoNeto"
    t.integer  "CodUnidPesoNeto"
    t.integer  "TotItems"
    t.integer  "TotBultos"
    t.string   "TpoMoneda"
    t.integer  "MntNeto"
    t.integer  "MntExe"
    t.integer  "MntBase"
    t.integer  "MntMargenCom"
    t.float    "TasaIVA"
    t.integer  "IVA"
    t.integer  "IVAProp"
    t.integer  "IVATerc"
    t.integer  "IVANoRet"
    t.integer  "CredEC"
    t.integer  "GrntDep"
    t.integer  "ValComNeto"
    t.integer  "ValComExe"
    t.integer  "ValComIVA"
    t.integer  "MntTotal"
    t.integer  "MontoNF"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "pdfs"
    t.text     "envio"
    t.string   "fileEnvio"
    t.string   "estado"
    t.text     "estadoxml"
    t.string   "pdft"
    t.text     "estadoEnvioXml"
    t.string   "trackidSII"
    t.string   "fileCliente"
    t.string   "fileFactura"
    t.string   "fileJson"
    t.string   "NomVendedor"
    t.string   "DirRegionalSII"
    t.string   "NombreCertificado"
    t.string   "FchResol"
    t.string   "BodEmis"
    t.string   "BodRecep"
    t.string   "TelRecep"
    t.string   "DirMatriz"
    t.string   "NroOrdenCompra"
    t.string   "CondVenta"
    t.string   "MedioPago"
  end

  create_table "dsc_rcg_globals", force: true do |t|
    t.integer  "NroLinDR"
    t.string   "TpoMov"
    t.string   "GlosaDR"
    t.string   "TpoValor"
    t.integer  "ValorDR"
    t.integer  "IndExeDR"
    t.integer  "documento_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "dsc_rcg_globals", ["documento_id"], name: "index_dsc_rcg_globals_on_documento_id", using: :btree

  create_table "dscrcgglobalcompras", force: true do |t|
    t.integer  "NroLinDR"
    t.string   "TpoMov"
    t.string   "GlosaDR"
    t.string   "TpoValor"
    t.integer  "ValorDR"
    t.integer  "IndExeDR"
    t.integer  "doccompra_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "dscrcgglobalcompras", ["doccompra_id"], name: "index_dscrcgglobalcompras_on_doccompra_id", using: :btree

  create_table "empresas", force: true do |t|
    t.string   "rznsocial"
    t.string   "rut"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "from"
    t.string   "rutenvia"
    t.string   "fechares"
    t.string   "numerores"
  end

  create_table "envioclientes", force: true do |t|
    t.integer  "folio"
    t.integer  "tipo"
    t.string   "rut"
    t.string   "rznsoc"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "iat_logs", force: true do |t|
    t.text     "description"
    t.integer  "iat_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "iat_logs", ["iat_id"], name: "index_iat_logs_on_iat_id", using: :btree

  create_table "iats", force: true do |t|
    t.string   "nombre"
    t.string   "sucursal"
    t.date     "ultimo_ping"
    t.string   "auth_token"
    t.date     "ping_inicio"
    t.string   "espacio_disco"
    t.string   "memoria"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "iats", ["user_id"], name: "index_iats_on_user_id", using: :btree

  create_table "imptoretencompras", force: true do |t|
    t.string   "TipoImp"
    t.float    "TasaImp"
    t.integer  "MontoImp"
    t.integer  "doccompra_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "imptoretencompras", ["doccompra_id"], name: "index_imptoretencompras_on_doccompra_id", using: :btree

  create_table "impuesto_retens", force: true do |t|
    t.string   "TipoImp"
    t.float    "TasaImp"
    t.integer  "MontoImp"
    t.integer  "documento_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "impuesto_retens", ["documento_id"], name: "index_impuesto_retens_on_documento_id", using: :btree

  create_table "installs", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "installs", ["email"], name: "index_installs_on_email", unique: true, using: :btree
  add_index "installs", ["reset_password_token"], name: "index_installs_on_reset_password_token", unique: true, using: :btree

  create_table "libros", force: true do |t|
    t.string   "rut"
    t.string   "tipo"
    t.string   "fecha"
    t.string   "idenvio"
    t.string   "xml"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "enviado"
    t.string   "fchenvio"
    t.string   "estado"
    t.text     "estadoxml"
    t.string   "tipolibro"
    t.string   "codautrec"
  end

  create_table "log_iats", force: true do |t|
    t.string   "sucursal"
    t.string   "rut"
    t.date     "ultimo_ping"
    t.integer  "tipo_dte"
    t.integer  "ultimo_folio"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "udtejson"
    t.datetime "ultimoping"
  end

  create_table "monto_pagos", force: true do |t|
    t.string   "FchPago"
    t.integer  "MntPago"
    t.integer  "documento_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "monto_pagos", ["documento_id"], name: "index_monto_pagos_on_documento_id", using: :btree

  create_table "mpagocompras", force: true do |t|
    t.string   "FchPago"
    t.integer  "MntPago"
    t.integer  "doccompra_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "mpagocompras", ["doccompra_id"], name: "index_mpagocompras_on_doccompra_id", using: :btree

  create_table "otrosimpcompmanuals", force: true do |t|
    t.string   "TipoImp"
    t.float    "TasaImp"
    t.integer  "MontoImp"
    t.integer  "compmanual_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "otrosimpcompmanuals", ["compmanual_id"], name: "index_otrosimpcompmanuals_on_compmanual_id", using: :btree

  create_table "otrosimpdetlibros", force: true do |t|
    t.string   "TipoImp"
    t.float    "TasaImp"
    t.integer  "MontoImp"
    t.integer  "detlibro_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "otrosimpdetlibros", ["detlibro_id"], name: "index_otrosimpdetlibros_on_detlibro_id", using: :btree

  create_table "otrosimpmanuals", force: true do |t|
    t.string   "TipoImp"
    t.float    "TasaImp"
    t.integer  "MontoImp"
    t.integer  "docmanual_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "otrosimpmanuals", ["docmanual_id"], name: "index_otrosimpmanuals_on_docmanual_id", using: :btree

  create_table "pruebas", force: true do |t|
    t.string   "rut"
    t.string   "nombre"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ref_detalles", force: true do |t|
    t.integer  "NroLinRef"
    t.string   "TpoDocRef"
    t.integer  "IndGlobal"
    t.string   "FolioRef"
    t.string   "RUTOtr"
    t.string   "IdAdicOtr"
    t.string   "FchRef"
    t.integer  "CodRef"
    t.string   "RazonRef"
    t.integer  "documento_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ref_detalles", ["documento_id"], name: "index_ref_detalles_on_documento_id", using: :btree

  create_table "refdetcompras", force: true do |t|
    t.integer  "NroLinRef"
    t.string   "TpoDocRef"
    t.integer  "IndGlobal"
    t.string   "FolioRef"
    t.string   "RUTOtr"
    t.string   "IdAdicOtr"
    t.string   "FchRef"
    t.integer  "CodRef"
    t.string   "RazonRef"
    t.integer  "doccompra_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "refdetcompras", ["doccompra_id"], name: "index_refdetcompras_on_doccompra_id", using: :btree

  create_table "subdsctos", force: true do |t|
    t.string   "TipoDscto"
    t.float    "ValorDscto"
    t.integer  "detcompra_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "subdsctos", ["detcompra_id"], name: "index_subdsctos_on_detcompra_id", using: :btree

  create_table "sucursals", force: true do |t|
    t.string   "nombre"
    t.string   "cdgsiisucur"
    t.integer  "empresa_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sucursals", ["empresa_id"], name: "index_sucursals_on_empresa_id", using: :btree

  create_table "tipodtes", force: true do |t|
    t.integer  "tipo"
    t.string   "nombre"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "manual"
    t.string   "nomdtepdf"
  end

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "nombres"
    t.string   "apellidos"
    t.string   "fono"
    t.string   "password"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "usuarioempresas", force: true do |t|
    t.string   "rutempresa"
    t.string   "useremail"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
