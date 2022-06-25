module Hai
  class Create
    attr_accessor :model

    def initialize(model)
      @model = model
    end

    def execute(**attrs)
      model.create(**attrs)
    end
  end
end
