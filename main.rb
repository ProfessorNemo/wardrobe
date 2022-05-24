require_relative 'lib/wardrobe'
require 'json'
require 'open-uri'
require 'rack'

# В константы CITY и WEATHER_APP_ID впишите название города и API-ключ,
# сгенерировав его по ссылке `https://home.openweathermap.org/users/sign_in`
CITY = 'Saint Petersburg'.freeze
WEATHER_APP_ID = '8c0fd2f53eb28557f1c657c927dd94a1'.freeze

WEATHER_API_URL = 'https://api.openweathermap.org/data/2.5/weather'.freeze
url = WEATHER_API_URL

query = Rack::Utils.build_query(
  'q' => CITY,
  'appid' => WEATHER_APP_ID,
  'units' => 'metric'
)

response = URI.parse("#{url}?#{query}").read
json = JSON.parse(response)
current_temperature = json['main']['temp'].round.to_i
puts "Текущая температура: #{current_temperature} C"

clothes_collection = Wardrobe.read_from_dir_files("#{__dir__}/data/*.txt")

clothes_list = clothes_collection.clothes_by_weather(current_temperature)

if clothes_list.empty?
  puts 'У вас нет подходящей одежды. Оставайтесь дома'
else
  puts 'Предлагаю надеть:', clothes_list
end

puts
puts 'Не нашли подходящих вещей в гардеробе?'
puts 'Хотите добавить новую вещь? (Y/N)'
answer = $stdin.gets.chomp.capitalize
until %w[Y N].include?(answer)
  puts 'Y - да, N - нет'
  answer = $stdin.gets.chomp.capitalize
end

case answer
when 'N'
  puts 'Всего хорошего'
when 'Y'
  puts 'Введите наименование'
  name = $stdin.gets.chomp.capitalize
  puts 'Введите категорию'
  type = $stdin.gets.chomp.capitalize
  puts 'Введите минимально допустимую температуру'
  min_temp = $stdin.gets.chomp
  puts 'Введите максимально допустимую температуру'
  max_temp = $stdin.gets.chomp

  add_params = { name: name, type: type, temp_range: "(#{min_temp}, #{max_temp})" }

  # создаем новую вещь
  new_thing = Thing.new(add_params)
  # записать файл с вещью
  new_thing.add_new_thing
  puts
  puts 'вещь добавлена!'
  puts 'Запустите программу снова для подбора одежды'
end
