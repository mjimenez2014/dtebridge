json.array!(@impuestos) do |impuesto|
  json.extract! impuesto, :id, :name, :tipoimp, :tasaimp, :montoimp, :descripcion, :validacion
  json.url impuesto_url(impuesto, format: :json)
end
