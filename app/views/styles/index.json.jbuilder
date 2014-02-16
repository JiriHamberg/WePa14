json.array!(@styles) do |style|
  json.extract! style, :id, :beer_id, :name, :description
  json.url style_url(style, format: :json)
end
