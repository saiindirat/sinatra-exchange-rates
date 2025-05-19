require 'dotenv/load'
require "sinatra"
require "sinatra/reloader"
require "http"

get("/") do
@raw_response = HTTP.get("https://api.exchangerate.host/list?access_key=#{ENV['EXCHANGE_RATE_KEY']}")

@string_response = @raw_response.to_s
@parsed_response = JSON.parse(@string_response)
@currencies = @parsed_response.fetch("currencies")
erb(:homepage)
end


get("/:first_symbol") do
  @the_symbol = params.fetch("first_symbol")
  erb(:step_one)
end
