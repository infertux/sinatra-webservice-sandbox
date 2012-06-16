require 'sinatra'
require 'sinatra/json'
require 'data_mapper'

#################
# Configuration #
#################

Dir["./models/*.rb"].each { |model| require model }

configure :development do
  DataMapper.setup(:default, 'sqlite:db/database.sqlite3')
  # DataMapper::Logger.new($stdout, :debug) # displays SQL queries
end
configure :test do
  DataMapper.setup(:default, 'sqlite::memory:')
end
DataMapper.finalize

set :json_encoder, :to_json
set :show_exceptions, false

#######################
# RESTful application #
#######################

# Returns all open services
get '/services' do
  json Service.all(open: true)
end

# Creates a new service if valid
post '/services/new' do
  service = Service.new(params[:service])
  if service.save
    status 201
    response['Location'] = service.url
  else
    status 422
    service.errors.values.join
  end
end

# Updates a service if valid
put '/services/:id' do
  service = Service.get(params[:id])
  if service.update(params[:service])
    status 200
  else
    status 422
    service.errors.values.join
  end
end

# Closes a service
post '/services/:id/close' do
  service = Service.get(params[:id])
  service.open = false
  service.save
end

# Up-votes a service
post '/services/:id/up' do
  service = Service.get(params[:id])
  service.up += 1
  service.save

  status 201
  response['Location'] = service.url
end

# Down-votes a service
post '/services/:id/down' do
  service = Service.get(params[:id])
  service.down += 1
  service.save

  status 201
  response['Location'] = service.url
end

# Creates a new comment
post '/services/:service_id/comments/new' do
  return 404 unless Service.get(params[:service_id])

  comment = Comment.new(params[:comment])
  comment.service_id = params[:service_id]

  if comment.save
    status 201
    response['Location'] = comment.url
  else
    status 422
    comment.errors.values.join
  end
end

# Returns the given comment of a service
get '/services/:service_id/comments/:id' do
  if comment = Comment.get(params[:id])
    json comment
  else
    status 404
  end
end

# Edit an existing comment
put '/services/:service_id/comments/:id' do
  return 404 unless comment = Comment.get(params[:id])

  if comment.update(params[:comment])
    status 200
  else
    status 422
    comment.errors.values.join
  end
end

# Deletes a comment
delete '/services/:service_id/comments/:id' do
  return 404 unless comment = Comment.get(params[:id])
  comment.destroy
end

# Returns all comments for the given service
get '/services/:id/comments' do
  return 404 unless Service.get(params[:id])

  json Comment.all(service_id: params[:id])
end

# Returns the given service
get '/services/:id' do
  if service = Service.get(params[:id])
    json service
  else
    status 404
  end
end

# Resets the database with fake data
get '/reset' do
  DataMapper.auto_migrate!

  Service.create!(
    title: "Statistics service",
    description: "Blah blah...",
    posted_by: "Joe",
    up: 5,
    down: 2
  )
  map = Service.create!(
    title: "Map service",
    description: "Blah blah...",
    posted_by: "John",
    up: 3,
    down: 6
  )

  Comment.create!(
    service_id: map.id,
    text: "It looks great!"
  )

  redirect '/services'
end

