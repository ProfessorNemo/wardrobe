require_relative 'lib/wardrobe'

clothes_collection = Wardrobe.read_from_dir_files("#{__dir__}/data/*.txt")
temperature = nil

until temperature =~ /-?\d+/
  puts 'Сколько градусов на улице?'
  temperature = $stdin.gets.strip
end

temperature = temperature.to_i

clothes_list = clothes_collection.clothes_by_weather(temperature)

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

# puts <<~LIST
#   \nСписок инстанс-методов класса Wardrobe"
#   #{Wardrobe.class.instance_methods.grep(/\?/)}\n
#   #{Wardrobe.singleton_class?}
# LIST
