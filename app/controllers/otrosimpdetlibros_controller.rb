class OtrosimpdetlibrosController < ApplicationController
  before_action :set_otrosimpdetlibro, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @otrosimpdetlibros = Otrosimpdetlibro.all
    respond_with(@otrosimpdetlibros)
  end

  def show
    respond_with(@otrosimpdetlibro)
  end

  def new
    @otrosimpdetlibro = Otrosimpdetlibro.new
    respond_with(@otrosimpdetlibro)
  end

  def edit
  end

  def create
    @otrosimpdetlibro = Otrosimpdetlibro.new(otrosimpdetlibro_params)
    @otrosimpdetlibro.save
    respond_with(@otrosimpdetlibro)
  end

  def update
    @otrosimpdetlibro.update(otrosimpdetlibro_params)
    respond_with(@otrosimpdetlibro)
  end

  def destroy
    @otrosimpdetlibro.destroy
    respond_with(@otrosimpdetlibro)
  end

  private
    def set_otrosimpdetlibro
      @otrosimpdetlibro = Otrosimpdetlibro.find(params[:id])
    end

    def otrosimpdetlibro_params
      params.require(:otrosimpdetlibro).permit(:TipoImp, :TasaImp, :MontoImp, :detlibro_id)
    end
end
