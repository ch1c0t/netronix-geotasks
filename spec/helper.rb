require_relative '../tracker'
require 'hobby/devtools/rspec_helper'

RSpec.configure do |config|
  config.before :each do
    Mongoid.purge!
    Task.create_indexes
  end
end
