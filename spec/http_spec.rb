require 'helper'
load 'seed_users.rb'

Hobby::Devtools::RSpec.describe do
  app { Tracker.new }
  format JSON
end
