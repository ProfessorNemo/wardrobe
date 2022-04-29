require_relative 'lib/wardrobe'
require 'pry-byebug'

clothes_collection = Wardrobe.read_from_dir_files("#{__dir__}/data/*.txt")
temperature = nil

until temperature =~ /-?\d+/
  puts 'Сколько градусов на улице?'
  temperature = $stdin.gets.strip
end

temperature = temperature.to_i

# temperature = $stdin.gets.strip
# unless temperature.match? /-?\d+/
#   puts 'Сколько градусов на улице?'
#   temperature = STDIN.gets.strip
# end

clothes_list = clothes_collection.clothes_by_weather(temperature)

if clothes_list.empty?
  puts 'У вас нет подходящей одежды'
else
  puts 'Предлагаю надеть:', clothes_list
end

# puts <<~LIST
#   \nСписок инстанс-методов класса Wardrobe"
#   #{Wardrobe.class.instance_methods.grep(/\?/)}\n
#   #{Wardrobe.singleton_class?}
# LIST
