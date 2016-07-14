class Documento < ActiveRecord::Base

  has_many :impuesto_retens, dependent: :destroy
  has_many :monto_pagos, dependent: :destroy
  has_many :dsc_rcg_globals, dependent: :destroy
  has_many :ref_detalles, dependent: :destroy
  has_many :comisions, dependent: :destroy
  has_many :detalles, dependent: :destroy
  has_many :sucursals

  accepts_nested_attributes_for :detalles
  accepts_nested_attributes_for :impuesto_retens
  accepts_nested_attributes_for :monto_pagos
  accepts_nested_attributes_for :dsc_rcg_globals
  accepts_nested_attributes_for :comisions
  accepts_nested_attributes_for :ref_detalles

  mount_uploader :pdfs, PdfsUploader # Tells rails to use this uploader for this model.
  mount_uploader :pdft, PdftUploader 
  mount_uploader :fileEnvio, FileEnvioUploader
  mount_uploader :fileCliente, PdfsUploader 
  mount_uploader :fileFactura, PdfsUploader
  mount_uploader :fileJson, PdfsUploader

  # searchable do
  #   time :created_at
  #   text :Folio, :sucursal, :FchEmis, :nombre_doc, :estado
  # end

  attr_reader :sucursal
  attr_reader :nombre_doc

  scope :sucursal, lambda {|sucursal| where('"CdgSIISucur" = ?', sucursal) if sucursal.present? }
  scope :tipodte, lambda {|tipodte| where('"TipoDTE" = ?',tipodte) if tipodte.present? }
  scope :folio, lambda {|folio| where('"Folio" = ?', folio) if  folio.present? }
  scope :fecha, lambda {|fecha| where(fecha: fecha) if fecha.present? }
 

  def sucursal
    nombre = " "
    sucursal = Sucursal.where(cdgsiisucur: "#{self.CdgSIISucur}" ).first
    unless sucursal.nil?
      nombre = sucursal.nombre
    end
    return nombre
  end

  def nombre_doc
    tipo = Tipodte.where(tipo: self.TipoDTE).first 
    return (tipo.nil? ? self.TipoDTE : tipo.nombre)
  end

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |document|
        csv << document.attributes.values_at(*column_names)
      end
    end
  end

  def self.sucursal_options_for_select(email)
    empresas = Empresa.where(:rut => Usuarioempresa.where(useremail:email).map {|u| u.rutempresa})
    Sucursal.where(:empresa_id => empresas.map {|e| e.id}).map {|s| s.nombre}
  end 

  def self.tipodte_option_for_select
    Tipodte.all.order(nombre: :asc).map {|t| [t.nombre, t.tipo]}
  end  
end
