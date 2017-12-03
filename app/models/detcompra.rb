class Detcompra < ActiveRecord::Base
  belongs_to :doccompra

  has_many :cdgitems, dependent: :destroy
  has_many :subdsctos, dependent: :destroy
  has_many :subcantidaddetcompras, dependent: :destroy

  accepts_nested_attributes_for :cdgitems
  accepts_nested_attributes_for :subdsctos
  accepts_nested_attributes_for :subcantidaddetcompras
  
end
