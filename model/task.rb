class Task
  include Mongoid::Document
  include Mongoid::Geospatial

  field :status,   type: Symbol, default: :new
  field :pickup,   type: Point, spatial: true
  field :delivery, type: Point

  validates_presence_of :status, :pickup, :delivery

  spatial_scope :pickup
  scope :near, -> location { nearby location.map &:to_f }

  belongs_to :user, optional: true

  def as_json (*)
    all = super
    all['id'] = all.delete('_id').to_s
    all['pickup'] = all['pickup'].reverse
    all['delivery'] = all['delivery'].reverse
    all
  end
end
