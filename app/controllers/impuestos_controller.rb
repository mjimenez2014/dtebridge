class ImpuestosController < ApplicationController
  before_action :set_impuesto, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @impuestos = Impuesto.all
    respond_with(@impuestos)
  end

  def show
    respond_with(@impuesto)
  end

  def new
    @impuesto = Impuesto.new
    respond_with(@impuesto)
  end

  def edit
  end

  def create
    @impuesto = Impuesto.new(impuesto_params)
    @impuesto.save
    respond_with(@impuesto)
  end

  def update
    @impuesto.update(impuesto_params)
    respond_with(@impuesto)
  end

  def destroy
    @impuesto.destroy
    respond_with(@impuesto)
  end

  private
    def set_impuesto
      @impuesto = Impuesto.find(params[:id])
    end

    def impuesto_params
      params.require(:impuesto).permit(:name, :tipoimp, :tasaimp, :montoimp, :descripcion, :validacion)
    end
end
