json.array!(@tipobultocompras) do |tipobultocompra|
  json.extract! tipobultocompra, :id, :CodTpoBultos, :CantBultos, :Marcas, :IdContainer, :Sello, :EmisorSello, :doccompra_id
  json.url tipobultocompra_url(tipobultocompra, format: :json)
end
