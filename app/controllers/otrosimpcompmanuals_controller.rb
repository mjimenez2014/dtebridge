class OtrosimpcompmanualsController < ApplicationController
  before_action :set_otrosimpcompmanual, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @otrosimpcompmanuals = Otrosimpcompmanual.all
    respond_with(@otrosimpcompmanuals)
  end

  def show
    respond_with(@otrosimpcompmanual)
  end

  def new
    @otrosimpcompmanual = Otrosimpcompmanual.new
    respond_with(@otrosimpcompmanual)
  end

  def edit
  end

  def create
    @compmanual = Compmanual.find(params[:compmanual_id])
    @otrosimpcompmanual = Otrosimpcompmanual.new(otrosimpcompmanual_params)
    @otrosimpcompmanual.save
    # respond_with(@otrosimpcompmanual)
    redirect_to compmanual_path(@compmanual)
  end

  def update
    @otrosimpcompmanual.update(otrosimpcompmanual_params)
    respond_with(@otrosimpcompmanual)
  end

  def destroy
    @otrosimpcompmanual.destroy
    respond_with(@otrosimpcompmanual)
  end

  private
    def set_otrosimpcompmanual
      @otrosimpcompmanual = Otrosimpcompmanual.find(params[:id])
    end

    def otrosimpcompmanual_params
      params.require(:otrosimpcompmanual).permit(:TipoImp, :TasaImp, :MontoImp, :compmanual_id)
    end
end
