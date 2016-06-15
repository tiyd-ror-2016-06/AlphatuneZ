require "./app"

run Rack::URLMap.new({
  "/" => Public,
  "/protected" => Protected
})

run MyApp
