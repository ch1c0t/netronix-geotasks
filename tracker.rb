require 'hobby'
require 'hobby/json'
require 'hobby/auth'

require 'mongoid'
require 'mongoid/geospatial'
Mongoid.connect_to 'testing_netronix_TestTask'

require_relative 'model/user'
require_relative 'model/manager'
require_relative 'model/driver'
require_relative 'model/task'
Task.create_indexes

class Tracker
  include Hobby
  include JSON
  include Auth[Manager]

  # Coordinates have to be reversed because the order specified
  # in the task's description is [latitude, longtitude],
  # which is the opposite to the Mongoid::Geospatial order.

  # Get all the tasks sorted by the nearness to the driver's location.
  #
  # As specified, it works with JSON data in the request's body,
  # but it should be noted that many people consider it a bad idea:
  # https://stackoverflow.com/questions/978061/http-get-with-request-body
  get { Task.near json['location'].reverse }

  # Create a new task.
  manager post { 
    Task.create \
      pickup:   json['pickup'].reverse,
      delivery: json['delivery'].reverse
  }
end
