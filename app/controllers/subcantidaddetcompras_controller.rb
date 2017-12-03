class SubcantidaddetcomprasController < ApplicationController
  before_action :set_subcantidaddetcompra, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @subcantidaddetcompras = Subcantidaddetcompra.all
    respond_with(@subcantidaddetcompras)
  end

  def show
    respond_with(@subcantidaddetcompra)
  end

  def new
    @subcantidaddetcompra = Subcantidaddetcompra.new
    respond_with(@subcantidaddetcompra)
  end

  def edit
  end

  def create
    @subcantidaddetcompra = Subcantidaddetcompra.new(subcantidaddetcompra_params)
    @subcantidaddetcompra.save
    respond_with(@subcantidaddetcompra)
  end

  def update
    @subcantidaddetcompra.update(subcantidaddetcompra_params)
    respond_with(@subcantidaddetcompra)
  end

  def destroy
    @subcantidaddetcompra.destroy
    respond_with(@subcantidaddetcompra)
  end

  private
    def set_subcantidaddetcompra
      @subcantidaddetcompra = Subcantidaddetcompra.find(params[:id])
    end

    def subcantidaddetcompra_params
      params.require(:subcantidaddetcompra).permit(:SubQty, :SubCod, :TipCodSubQty, :detcompra_id)
    end
end
