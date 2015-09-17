require './reviews_migration'
require './department'
require './employee'

ReviewsMigration.migrate(:up)
