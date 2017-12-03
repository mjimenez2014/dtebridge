json.array!(@impretotrmndacompras) do |impretotrmndacompra|
  json.extract! impretotrmndacompra, :id, :TipoImpOtrMnda, :TasaImpOtrMnda, :VlrImpOtrMnda, :doccompra_id
  json.url impretotrmndacompra_url(impretotrmndacompra, format: :json)
end
