class Comment
  include DataMapper::Resource

  property :id, Serial
  property :service_id, Integer, required: true
  property :posted_by, String, required: true
  property :text, String, required: true
  property :created_at, DateTime
  property :updated_at, DateTime

  def to_s
    text
  end

  def url
    "/services/#{service_id}/comments/#{id}"
  end
end


