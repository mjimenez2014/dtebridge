class Contribuyente < ActiveRecord::Base
  validates :rut, :presence => {:message => "Este campo no puede estar vacío!"}, length: {minimum: 10, maximum: 10, :message => "RUT Ejemplo: 19987987-K"},:uniqueness=> {:message => " el Contribuyente ya existe!!!"}
  validates :nombre, :presence => {:message => "Este campo no puede estar vacío!"}
  validates :email, :presence => {:message => "Este campo no puede estar vacío!"}

  require 'csv'
  def self.import(file)
    CSV.foreach(file.path, col_sep: ';', headers: true, encoding: "ISO-8859-1" ) do |row|
      rowHash = row.to_hash
      
      #puts "================="
      #puts rowHash
      res = Contribuyente.new(rowHash)
      res.save
    end
  end
end
