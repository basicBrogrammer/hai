module Hai
  class Create
    attr_accessor :model
    attr_reader :table

    def initialize(model)
      @model = model
    end

    def execute(id:, attributes:)
      record = model.find(id)
      record.update(**attributes)
    end
  end
end
