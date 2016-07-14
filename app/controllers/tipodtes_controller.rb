class TipodtesController < ApplicationController
  before_action :set_tipodte, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @tipodtes = Tipodte.all
    respond_with(@tipodtes)
  end

  def show
    respond_with(@tipodte)
  end

  def new
    @tipodte = Tipodte.new
    respond_with(@tipodte)
  end

  def edit
  end

  def create
    @tipodte = Tipodte.new(tipodte_params)
    @tipodte.save
    respond_with(@tipodte)
  end

  def update
    @tipodte.update(tipodte_params)
    respond_with(@tipodte)
  end

  def destroy
    @tipodte.destroy
    respond_with(@tipodte)
  end

  private
    def set_tipodte
      @tipodte = Tipodte.find(params[:id])
    end

    def tipodte_params
      params.require(:tipodte).permit(:tipo, :nombre, :nomdtepdf)
    end
end
