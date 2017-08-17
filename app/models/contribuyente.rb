class Contribuyente < ActiveRecord::Base

  validates :rut, :presence => {:message => "Este campo no puede estar en blanco!"}, length: {minimum: 10, maximum: 10, :message => "RUT Ejemplo: 19987987-K"},:uniqueness=> {:message => " el Contribuyente ya existe!!!"}
  validates :nombre, :presence => {:message => "Este campo no puede estar en blanco!"}
  validates :email, :presence => {:message => "Este campo no puede estar en blanco!"}


  require 'csv'
    def self.import(file)
   count = 0
   CSV.foreach(file.path, col_sep: ';', headers: true, encoding: "ISO-8859-1" ) do |row|
      product_hash = row.to_hash # exclude the price field
      imp = Contribuyente.where(rut: product_hash["rut"])
      if imp.count == 1
        imp.first.update_attributes(product_hash)
        count +=1
        puts "Actualizado => " + product_hash["rut"].to_s + " " + count.to_s
      else
        Contribuyente.create!(product_hash)
        count +=1
        puts "Creado => " + product_hash["rut"].to_s + " " + count.to_s
      end # end if !product.nil?
    end # end CSV.foreach
  end

end
