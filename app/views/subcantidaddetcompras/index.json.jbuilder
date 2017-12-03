json.array!(@subcantidaddetcompras) do |subcantidaddetcompra|
  json.extract! subcantidaddetcompra, :id, :SubQty, :SubCod, :TipCodSubQty, :detcompra_id
  json.url subcantidaddetcompra_url(subcantidaddetcompra, format: :json)
end
