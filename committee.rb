require 'active_record'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'development.sqlite3'
)

class Committee < ActiveRecord::Base
  has_and_belongs_to_many :employees

end
