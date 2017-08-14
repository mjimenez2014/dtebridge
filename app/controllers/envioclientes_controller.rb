class EnvioclientesController < ApplicationController
  before_action :set_enviocliente, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    if params["rut_recep"].present?
       @envioclientes = Enviocliente.where(rut: params["rut_recep"]).order(created_at: :desc).paginate(:page => params[:page], :per_page => 15 )
       respond_with(@envioclientes)
    else  
      @envioclientes = Enviocliente.all.order(created_at: :desc).paginate(:page => params[:page], :per_page => 15 )
      respond_with(@envioclientes)
    end
  end

  def show
    respond_with(@enviocliente)
  end

  def new
    @enviocliente = Enviocliente.new
    respond_with(@enviocliente)
  end

  def edit
  end

  def create
    @enviocliente = Enviocliente.new(enviocliente_params)
    @enviocliente.save
    respond_with(@enviocliente)
  end

  def update
    @enviocliente.update(enviocliente_params)
    respond_with(@enviocliente)
  end

  def destroy
    @enviocliente.destroy
    respond_with(@enviocliente)
  end

  private
    def set_enviocliente
      @enviocliente = Enviocliente.find(params[:id])
    end

    def enviocliente_params
      params.require(:enviocliente).permit(:folio, :tipo, :rut, :rznsoc)
    end
end
