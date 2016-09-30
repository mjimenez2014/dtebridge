Dtebridge::Application.routes.draw do

  
  resources :usuarioempresas

  resources :envioclientes


  resources :compmanuals do
    collection { post :import }
  end

  resources :docmanuals do
    collection { post :import }
  end

  resources :doccompras do
    collection { post :import }
  end

  resources :log_iats
  resources :otrosimpmanuals
  resources :otrosimpcompmanuals
  resources :tipodtes
  resources :sucursals
  resources :empresas
  resources :subdsctos
  resources :cdgitems
  resources :comisioncompras
  resources :refdetcompras
  resources :dscrcgglobalcompras
  resources :imptoretencompras
  resources :mpagocompras
  resources :docsemails
  resources :doccompras
  resources :comisions
  resources :ref_detalles
  resources :dsc_rcg_globals
  resources :impuesto_retens
  resources :monto_pagos
  resources :detalles
  resources :documentos
  resources :iat_logs
  resources :iats
  resources :libros
  
  devise_for :installs
  devise_for :users

  get "report/venta"
  post "report/find", to: "report#find"
  get "report/compra"
  post "report/findCompra", to: "report#findCompra"

  get "detlibrovta/index"
  get "uploadformat/index"
  get "newuser/index"
  get "detlibro/index"


  get "libro_compra/index"
  post "buscarLibroCompra", to: "libro_compra#find"
  get "libro_compra/generalibro", to: "libro_compra#generalibro"

  get "listalibro/index"
  get "home/index"
  get "libro_venta/index"
  post "buscarLibrovta", to: "libro_venta#find"
  get "libro_venta/generalibro", to: "libro_venta#generalibro"

  get "listalibro/sendsii/:id", to: "listalibro#sendsii"

 
  get "doccompras_aprob/index"
  get "doccompras_rech/index"
  get "get_siitoken", to: "connectsii#get_token"
  get "postsii" , to: "connectsii#postsii"
  get "setDTE" , to: "connectsii#createenvio"
  get "respIntercam" , to: "connectsii#resp_intercambio"
  get "recepMercaderia" , to: "connectsii#recep_mercaderia"
  get "aprobComercial" , to: "connectsii#aprob_comercial"
  get "estadistica/index"
  get "estadistica", to: "estadistica#index"
  get "/contribuyentes/upload", to: "contribuyentes#upload"
 
  get "listalibro/genxml/:id", to: "listalibro#genxml"
  get "listalibro/sendxml/:id", to: "listalibro#sendxml"
  get "detlibro/index/:id", to: "detlibro#index"

  get "detcompras/:id", to: "detcompras#index"
  
  get "doccompras/rechazar/:id", to: "doccompras#rechazar"
  get "doccompras/aprobar/:id", to: "doccompras#aprobar"
  get "doccompras/sendxml/:id", to: "doccompras#sendxml"
  get "doccompras_aprob/rechazar/:id", to: "doccompras_aprob#rechazar"
  get "doccompras_rech/aprobar/:id", to: "doccompras_rech#aprobar"
  get "doccompras_aprob", to: "doccompras_aprob#index"
  get "doccompras_rech", to: "doccompras_rech#index"
  get "doccompras/print/:id", to: "doccompras#print"
  get "doccompras/ver/:id", to: "doccompras#ver"



  post "buscarDoc", to: "documentos#find"

  get "documentos/download", to: "documentos#download"

  get "/daradmin/permisos", to: "daradmin#index"
  get "/daradmin/:id", to: "daradmin#daradmin"
  get "/daradmin/quitaradmin/:id", to: "daradmin#quitaradmin"

  get "/newuser/index", to: "newuser#index"
  post "/newuser/new", to: "newuser#new"

  get "/uploadformat/fileventas", to: "uploadformat#sendfileventas"
  get "/uploadformat/filecompras", to: "uploadformat#sendfilecompras"

  root to: "home#index"

  resources :contribuyentes do
    collection { post :import }
  end

  namespace :api do
    namespace :v1 do
      post "/pruebas", to: "pruebas#create"
      post "/iat_doc", to: "iat#iat_doc"
      post "/invoice", to: "documento#create_doc"
      get  "/pruebas", to: "pruebas#index"
      get "/iat_login", to: "iat#login"
      get "/iat_ping/:id", to: "iat#ping"
      get "/iat_offline", to: "iat#isoffline"
      get "/gettoken", to: "documento#get_token"
      get "/procestado", to: "documento#procesoEstado"
      get "/notification", to: "notification#send_notif"
      get "/procesarecibo", to: "doccompra#procesarecibo"
      get "/procesarecibo2", to: "doccompra#procesarecibo2"      
      get "/resend", to: "documento#resend"
      get "/sendclient", to: "documento#sendclient"
      get "/separchivo", to: "separchivo#separchivo"
      get "/readmail", to: "readmail#read_mail"
     end
  end

end
