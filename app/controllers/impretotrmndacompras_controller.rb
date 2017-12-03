class ImpretotrmndacomprasController < ApplicationController
  before_action :set_impretotrmndacompra, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @impretotrmndacompras = Impretotrmndacompra.all
    respond_with(@impretotrmndacompras)
  end

  def show
    respond_with(@impretotrmndacompra)
  end

  def new
    @impretotrmndacompra = Impretotrmndacompra.new
    respond_with(@impretotrmndacompra)
  end

  def edit
  end

  def create
    @impretotrmndacompra = Impretotrmndacompra.new(impretotrmndacompra_params)
    @impretotrmndacompra.save
    respond_with(@impretotrmndacompra)
  end

  def update
    @impretotrmndacompra.update(impretotrmndacompra_params)
    respond_with(@impretotrmndacompra)
  end

  def destroy
    @impretotrmndacompra.destroy
    respond_with(@impretotrmndacompra)
  end

  private
    def set_impretotrmndacompra
      @impretotrmndacompra = Impretotrmndacompra.find(params[:id])
    end

    def impretotrmndacompra_params
      params.require(:impretotrmndacompra).permit(:TipoImpOtrMnda, :TasaImpOtrMnda, :VlrImpOtrMnda, :doccompra_id)
    end
end
