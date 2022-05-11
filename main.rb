require_relative 'lib/wardrobe'
require 'rack'
require 'open-uri'
require 'json'
require 'addressable'

# В константы CITY и WEATHER_APP_ID впишите название города и API-ключ,
# сгенерировав его по ссылке `https://home.openweathermap.org/users/sign_in`
CITY = 'Saint Petersburg'.freeze
WEATHER_APP_ID = 'API-key'.freeze

WEATHER_API_URL = 'https://api.openweathermap.org/data/2.5/weather/'.freeze
url = WEATHER_API_URL

query = Rack::Utils.build_query(
  'q' => CITY,
  'APPID' => WEATHER_APP_ID,
  'units' => 'metric'
)

# response = URI.open("#{url}?#{query}").read
response = URI.open(Addressable::URI.encode("#{url}?#{query}")).read
json = JSON.parse(response)
current_temperature = json['main']['temp'].round.to_i
puts "Текущая температура: #{current_temperature} C"

clothes_collection = Wardrobe.read_from_dir_files("#{__dir__}/data/*.txt")

clothes_list = clothes_collection.clothes_by_weather(current_temperature)

if clothes_list.empty?
  puts 'У вас нет подходящей одежды'
else
  puts 'Предлагаю надеть:', clothes_list
end
