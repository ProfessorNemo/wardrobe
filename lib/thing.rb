module GenRange
  private

  def parse_range(range_string)
    Range.new(*range_string.scan(/-?\d+-?/).map(&:to_i))
  end
end

class Thing
  # extend GenRange
  attr_reader :name, :type, :temp_range

  class << self
    include GenRange
    def read_file(path)
      lines = File.readlines(path, chomp: true)
      new(name: lines[0], type: lines[1], temp_range: parse_range(lines[2]))
    end
  end

  def initialize(params)
    @name = params[:name]
    @type = params[:type]
    @temp_range = params[:temp_range]
  end

  def to_s
    "#{name} (#{type})"
  end

  def suitable?(temperature)
    temp_range.include?(temperature)
  end
end
