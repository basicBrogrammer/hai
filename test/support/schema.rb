ActiveRecord::Schema.define do
  self.verbose = false

  create_table :users, force: true do |t|
    t.string :name
    t.timestamps
  end

  create_table :rides, force: true do |t|
    t.string :title
    t.belongs_to :user
    t.timestamps
  end
end
