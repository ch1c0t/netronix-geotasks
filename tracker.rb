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
  include Auth[Manager, Driver]

  # Coordinates have to be reversed because the order specified
  # in the task's description is [latitude, longtitude],
  # which is the opposite to the Mongoid::Geospatial order.

  # Get all the tasks sorted by the nearness to the driver's location.
  #
  # As specified, it works with JSON data in the request's body,
  # but it should be noted that many people consider it a bad idea:
  # https://stackoverflow.com/questions/978061/http-get-with-request-body
  driver get { Task.near json['location'].reverse }

  # Create a new task.
  manager post { 
    Task.create \
      pickup:   json['pickup'].reverse,
      delivery: json['delivery'].reverse
  }

  # Change the task's status.
  driver patch('/:id') {
    status, id = json['status'], my[:id]

    case status
    when 'assigned'
      user.task = Task.find id
      user.task.status = status
    when 'done'
      task = Task.find id

      if task == user.task
        task.status = status
      else
        response.status = 403
        'You are trying to mark as done a task not assigned to you.'
      end
    end
  }
end
