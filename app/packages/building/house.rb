module Building
  class House
    def initialize(size:)
      @size = size
      @vehicle = Vehicle::Car.new
      @bed = Furniture::Expensive::Bed.new
      @table = Furniture::Table.new
      @chair = Furniture::Chair.new
    end
  end
end
