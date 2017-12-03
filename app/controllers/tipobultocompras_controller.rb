class TipobultocomprasController < ApplicationController
  before_action :set_tipobultocompra, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @tipobultocompras = Tipobultocompra.all
    respond_with(@tipobultocompras)
  end

  def show
    respond_with(@tipobultocompra)
  end

  def new
    @tipobultocompra = Tipobultocompra.new
    respond_with(@tipobultocompra)
  end

  def edit
  end

  def create
    @tipobultocompra = Tipobultocompra.new(tipobultocompra_params)
    @tipobultocompra.save
    respond_with(@tipobultocompra)
  end

  def update
    @tipobultocompra.update(tipobultocompra_params)
    respond_with(@tipobultocompra)
  end

  def destroy
    @tipobultocompra.destroy
    respond_with(@tipobultocompra)
  end

  private
    def set_tipobultocompra
      @tipobultocompra = Tipobultocompra.find(params[:id])
    end

    def tipobultocompra_params
      params.require(:tipobultocompra).permit(:CodTpoBultos, :CantBultos, :Marcas, :IdContainer, :Sello, :EmisorSello, :doccompra_id)
    end
end
