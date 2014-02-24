json.array!(@breweries) do |brewery|
  json.extract! brewery, :id, :name, :year
  json.beerCount brewery.beers.size
end
