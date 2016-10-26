json.array!(@otrosimpdetlibros) do |otrosimpdetlibro|
  json.extract! otrosimpdetlibro, :id, :TipoImp, :TasaImp, :MontoImp, :detlibro_id
  json.url otrosimpdetlibro_url(otrosimpdetlibro, format: :json)
end
