require File.dirname(__FILE__) + '/spec_helper'

describe 'App' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def service_attributes
    {
      title: "Test service",
      posted_by: "Tester"
    }
  end

  def comment_attributes
    {
      text: "Test comment",
      posted_by: "Tester"
    }
  end

  def create_service
   service = Service.create! service_attributes
  end

  def create_comment service
   service = Comment.create!(comment_attributes.merge({service_id: service.id}))
  end

  it "lists all services" do
    service = create_service

    get '/services'
    last_response.status.should == 200
    last_response.body.should include service.to_s
  end

  it "does not list closed services" do
    service = create_service
    service.open = false
    service.save

    get '/services'
    last_response.status.should == 200
    last_response.body.should_not include service.to_s
  end

  it "adds a new service" do
    expect {
      post "/services/new", service: service_attributes
    }.to change{ Service.count }.by(1)

    last_response.status.should == 201
    last_response.headers['Location'].should_not be_nil
  end

  it "up-votes a service" do
    service = create_service

    expect {
      post "#{service.url}/up"
    }.to change{ service.reload.up }.by(1)
  end

  it "down-votes a service" do
    service = create_service

    expect {
      post "#{service.url}/down"
    }.to change{ service.reload.down }.by(1)
  end

  it "adds a comment on a service" do
    service = create_service

    expect {
      post "#{service.url}/comments/new", comment: comment_attributes
    }.to change{ service.reload.comment.count }.by(1)
  end

  it "deletes a comment on a service" do
    service = create_service
    comment = create_comment service

    expect {
      delete comment.url
    }.to change{ service.reload.comment.count }.by(-1)
  end

end

