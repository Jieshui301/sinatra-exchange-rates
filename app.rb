require "sinatra"
require "sinatra/reloader"
require "http"
require "json"

get("/") do
  api_url = "https://api.exchangerate.host/list?access_key=#{ENV['EXCHANGE_RATE_KEY']}"

  raw_data = HTTP.get(api_url)
  raw_data_string = raw_data.to_s
  @parsed_data = JSON.parse(raw_data_string)

  @source = @parsed_data.fetch("currencies")

  erb(:homepage)
end

get("/:from_currency") do
  @original_currency = params.fetch("from_currency")

  api_url = "https://api.exchangerate.host/list?access_key=#{ENV["EXCHANGE_RATE_KEY"]}"
  
  raw_data = HTTP.get(api_url)
  raw_data_string = raw_data.to_s
  @parsed_data = JSON.parse(raw_data_string)

  @source = @parsed_data.fetch("currencies")

  erb(:from_currency)
end

get("/:from_currency/:to_currency") do
  @original_currency = params.fetch("from_currency")
  @destination_currency = params.fetch("to_currency")

  api_url = "https://api.exchangerate.host/convert?access_key=#{ENV['EXCHANGE_RATE_KEY']}&from=#{@original_currency}&to=#{@destination_currency}&amount=1"
  raw_response = HTTP.get(api_url)
  @parsed_data = JSON.parse(raw_response.to_s)

  if @parsed_data.fetch("success", false)
    @conversion_result = @parsed_data.fetch("result")
  else
    # Handle the scenario where the API response indicates failure
    @conversion_result = nil
  end

  erb(:from_to_currency)
end
