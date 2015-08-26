class ContribuyentesController < ApplicationController
 # before_action :set_contribuyente, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @contribuyentes = Contribuyente.all
    respond_with(@contribuyentes)
  end

  def show
    respond_with(@contribuyente)
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
    Contribuyente.destroy_all
    
    Contribuyente.import(params[:file])

    @contribuyentes = Contribuyente.all
    respond_with(@contribuyentes)
  end

  private
    def set_contribuyente
      @contribuyente = Contribuyente.find(params[:id])
    end

    def contribuyente_params
      params.require(:contribuyente).permit(:rut, :nombre, :email)
    end
end
