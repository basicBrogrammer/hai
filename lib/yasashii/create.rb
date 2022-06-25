module Yasashii
  class Create
    attr_accessor :model
    attr_reader :table

    def initialize(model)
      @model = model
      @table = model.arel_table
    end

    def execute(**attrs)
      model.create(**attrs)
    end
  end
end
