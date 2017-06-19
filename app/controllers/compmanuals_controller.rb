# encoding: ISO-8859-1
class CompmanualsController < ApplicationController
  before_action :set_compmanual, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @compmanuals = Compmanual.where(estado: "PREVIO")
    respond_with(@compmanuals)
  end

  def show
    @impuestos = Impuesto.all
    @otrosimp = Otrosimpcompmanual.where(compmanual_id: @compmanual.id).all
    respond_with(@compmanual)
  end

  def update
    respond_to do |format|
      if @compmanual.update(compmanual_params)
        format.html { redirect_to @compmanual, notice: 'Compmanual was successfully updated.' }
        format.json { render :show, status: :ok, location: @compmanual }
      else
        format.html { render :edit }
        format.json { render json: @compmanual.errors, status: :unprocessable_entity }
      end
    end
  end

  def import
    @compmanuals = Compmanual.where(estado: "PREVIO")
    @msg = Compmanual.import(params[:file]).force_encoding('utf-8')
    respond_to do |format|
      format.html {
        if @msg == " "
          render action: 'index', notice: "Documentos Ok"
        else
          render '/compmanuals/error'
        end  
      }
    end   
  end

  def new
    @compmanual = Compmanual.new
    @tipodtes = Tipodte.where(:tipo => [33,61,60,52,34])
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @compmanual }
    end
  end

  def create
    @compmanual = Compmanual.new(compmanual_params)
    #puts "======== PARAMS ==========="
    #puts compmanual_params
    #puts "============================"
    respond_to do |format|
      if @compmanual.save
        format.html { redirect_to @compmanual, notice: 'Compmanual was successfully created.' }
        format.xml  { render :xml => @compmanual, :status => :created, :location => @compmanual }
      else
        format.html { render :new }
        format.json { render json: @compmanual.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @compmanual.destroy
    respond_with(@compmanual)
  end

  private
    def set_compmanual
      @compmanual = Compmanual.find(params[:id])
    end

    def compmanual_params
      params.require(:compmanual).permit(:tipodoc, :folio, :fchemis, :rutemisor, :rutrecep, :rznsocemisor, :mntneto, :mntexe, :mntiva, :otrosimpto, :mnttotal, :impto18, :impto10, :impto25, :impto30, :estado)
    end
end
