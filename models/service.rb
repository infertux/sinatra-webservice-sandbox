class Service
  include DataMapper::Resource

  property :id, Serial
  property :title, String, required: true
  property :description, Text
  property :posted_by, String, required: true
  property :up, Integer, default: 0
  property :down, Integer, default: 0
  property :open, Boolean, default: true
  property :created_at, DateTime
  property :updated_at, DateTime

  has n, :comment

  def to_s
    title
  end

  def url
    "/services/#{id}"
  end
end

