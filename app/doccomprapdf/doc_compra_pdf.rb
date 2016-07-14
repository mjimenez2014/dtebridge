class DocCompraPdf < Prawn::Document
	def initialize(doccompra)
		super(top_margin: 10)
		stroke_circle [0, 0], 10	
		@doccompra = doccompra
		@nomtipodte = Tipodte.where(tipo: @doccompra.TipoDTE).last.nomdtepdf
		text "Tipo Dte: #{@nomtipodte}"
	end
end	
