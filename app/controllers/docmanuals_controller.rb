class DocmanualsController < ApplicationController
  before_action :set_docmanual, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @docmanuals = Docmanual.where(estado: "PREVIO").where(:rutemisor => Usuarioempresa.where(useremail:current_user.email).map {|u| u.rutempresa})
    totFmanual = Docmanual.select('sum("mntneto") as mntneto,sum("mntexe") as mntexe, sum("mntiva") as iva, sum("mnttotal") as mnttotal,sum(impto10+impto18+impto25+impto30) as otrosimp, count(*) as count').where('"estado" = ? AND "tipodoc" <> 52 and "tipodoc"<>60', "PREVIO").where(:rutemisor => Usuarioempresa.where(useremail:current_user.email).map {|u| u.rutempresa})
    totFmanual.map { |e| @totFmanual = e }
    
    respond_with(@docmanuals)
  end

  def destroy
    @docmanual.destroy
    respond_with(@docmanual)
  end

  def import
    @docmanuals = Docmanual.where(estado: "PREVIO").where(:rutemisor => Usuarioempresa.where(useremail:current_user.email).map {|u| u.rutempresa})
    totFmanual = Docmanual.select('sum("mntneto") as mntneto,sum("mntexe") as mntexe, sum("mntiva") as iva, sum("mnttotal") as mnttotal,sum(impto10+impto18+impto25+impto30) as otrosimp, count(*) as count').where('"tipodoc" <> 52 and "tipodoc"<>60').where(:rutemisor => Usuarioempresa.where(useremail:current_user.email).map {|u| u.rutempresa})
    totFmanual.map { |e| @totFmanual = e }
   
    @msg = Docmanual.import(params[:file])
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


  private
    def set_docmanual
      @docmanual = Docmanual.find(params[:id])
    end

    def docmanual_params
      params.require(:docmanual).permit(:tipodoc, :folio, :fchemis, :rutemisor, :rutrecep, :rznsocrecep, :mntneto, :mntexe, :mntiva, :otrosimpto, :mnttotal, :impto18, :impto10, :impto25, :impto30, :estado, :anulado)
    end
end
