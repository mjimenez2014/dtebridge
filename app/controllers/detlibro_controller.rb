class DetlibroController < ApplicationController

  def index
    @libro = Libro.find(params[:id])
    @detalles =  @libro.detlibro.order(tipodte: :asc , folio: :asc )

    @detlibro = @libro.detlibro.select('tipodte,sum("mntiva") as mntiva,tipodte,sum("mntneto") as mntneto,sum("mntsincred") as mntsincred,sum("mnttotal") as mnttotal,sum("mntexe") as mntexe, count(*) as count').group('"tipodte"')
  end
end
