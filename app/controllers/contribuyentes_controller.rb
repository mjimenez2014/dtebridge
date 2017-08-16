class ContribuyentesController < ApplicationController
  before_action :set_contribuyente, only: [:show, :edit, :update, :destroy]

  respond_to :html,:json

  def index
     @contribuyenteAll = Contribuyente.count
    if params["rut"].present?
     @contribuyente = Contribuyente.where(rut: params["rut"]).paginate(:page => params[:page], :per_page => 15 )
    else
     @contribuyente = Contribuyente.all.paginate(:page => params[:page], :per_page => 15 )
    end

    respond_with(@contribuyente)
  end

  def show
    respond_with(@contribuyente)
  end

  def busca_por_rut
    @contribuyente = Contribuyente.where(rut: params['rut']).first
    render '/contribuyentes/busca_por_rut.json'
  end

  def new
    @contribuyente = Contribuyente.new
    respond_with(@contribuyente)
  end

  def edit
  end

  def create
    @contribuyente = Contribuyente.new(contribuyente_params)
    @contribuyente.save
    respond_with(@contribuyente)
  end

  def update
    @contribuyente.update(contribuyente_params)
    respond_with(@contribuyente)
  end

  def destroy
    @contribuyente.destroy
    respond_with(@contribuyente)
  end

  def upload
    respond_to do |format|
      format.html { render '/contribuyentes/upload' }
    end  
  end

  def import
   
   # Contribuyente.delete_all
   
    Contribuyente.import(params[:file])

    @contribuyentes = Contribuyente.count
    respond_with(@contribuyentes)
  end

  private
    def set_contribuyente
      if params[:id].present?
       @contribuyente = Contribuyente.find(params[:id])
      else
       @contribuyente = Contribuyente.find(params[:rut])
      end
    end

    def contribuyente_params
      params.require(:contribuyente).permit(:rut, :nombre, :email)
    end
end
