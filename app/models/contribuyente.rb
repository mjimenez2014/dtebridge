class Contribuyente < ActiveRecord::Base

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
