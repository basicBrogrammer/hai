module Hai
  class Delete
    attr_accessor :model
    attr_reader :table

    def initialize(model)
      @model = model
    end

    def execute(id:)
      record = model.find(id)
      record.destroy
    end
  end
end
