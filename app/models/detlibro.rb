class Detlibro < ActiveRecord::Base
  belongs_to :libro
  has_many :otrosimpdetlibro, dependent: :destroy

  def nombre_doc
    tipo = Tipodte.where(tipo: self.tipodte).first 
  return (tipo.nil? ? self.tipodte : tipo.nombre)
  end
end
