class DoccomprasAprobController < ApplicationController
  respond_to :html
  def index
    @doccompras = Doccompra.where(estado: "APROBADO")
  end

  def rechazar
    d = Doccompra.find(params[:id])
    d.estado = "RECHAZADO"
    d.save

    @doccompras = Doccompra.where(estado: "APROBADO")
    respond_to do |format|
        format.html { render action: 'index'}
    end    
  end


end
