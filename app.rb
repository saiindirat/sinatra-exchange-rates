require "sinatra"
require "sinatra/reloader"
require "http"
require "json"
require "dotenv/load"  # Loads .env file so ENV['EXCHANGE_RATE_KEY'] works

# Homepage: Fetch list of currencies and show homepage
get("/") do
  url = "https://api.exchangerate.host/list?access_key=#{ENV.fetch("EXCHANGE_RATE_KEY").chomp}"
  response = HTTP.get(url)
  parsed = JSON.parse(response.to_s)

  @currencies = parsed.fetch("currencies", {})  # Safe fallback if nil
  erb :homepage
end

# Step One: User selects a base currency
get("/:from_currency") do
  @the_symbol = params.fetch("from_currency")

  url = "https://api.exchangerate.host/list?access_key=#{ENV.fetch("EXCHANGE_RATE_KEY").chomp}"
  response = HTTP.get(url)
  parsed = JSON.parse(response.to_s)

  @currencies = parsed.fetch("currencies", {})
  erb :step_one
end

# Step Two: User selects a target currency and sees the conversion
get("/:from_currency/:to_currency") do
  @from = params.fetch("from_currency")
  @to = params.fetch("to_currency")

  url = "https://api.exchangerate.host/convert?from=#{@from}&to=#{@to}&amount=1&access_key=#{ENV.fetch("EXCHANGE_RATE_KEY").chomp}"
  response = HTTP.get(url)
  parsed = JSON.parse(response.to_s)

  @amount = parsed["result"] || "N/A"  # Show fallback if conversion fails
  erb :step_two
end

