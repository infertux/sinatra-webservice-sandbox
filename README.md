# Sinatra RESTful Web Service

Just an experiment with Sinatra and DataMapper to make a RESTful/JSON web service.

## Install the application

`bundle install`

## Run the application

`foreman start`

## Tests
### Run the tests

`rake` runs the whole testsuite.

### Testing with CURL

Here are a couple of example REST requests using `curl`:

    curl -i -H "Accept: application/json" http://localhost:4567/services
    curl -i -H "Accept: application/json" http://localhost:4567/services/1
    curl -i -H "Accept: application/json" http://localhost:4567/services/2

    curl -i -H "Accept: application/json" -X POST -d "service[title]=Curl&service[posted_by]=curl" http://localhost:4567/services/new
    curl -i -H "Accept: application/json" -X PUT -d "service[title]=Curly" http://localhost:4567/services/1

    curl -i -H "Accept: application/json" -X POST -d "comment[text]=Yop&comment[posted_by]=Me" http://localhost:4567/services/2/comments/new

    curl -i -H "Accept: application/json" -X POST -d "" http://localhost:4567/services/1/up
    curl -i -H "Accept: application/json" -X POST -d "" http://localhost:4567/services/1/down
    curl -i -H "Accept: application/json" -X POST -d "" http://localhost:4567/services/1/close

    curl -i -H "Accept: application/json" -X GET http://localhost:4567/services/2/comments
    curl -i -H "Accept: application/json" -X GET http://localhost:4567/services/2/comments/1
    curl -i -H "Accept: application/json" -X DELETE http://localhost:4567/services/2/comments/1

## Routes

Here is the exhaustive list of entry points of the web service:

    GET     "/services"
    GET     "/services/:service_id/comments/:id"
    GET     "/services/:id/comments"
    GET     "/services/:id"
    HEAD    "/services"
    HEAD    "/services/:service_id/comments/:id"
    HEAD    "/services/:id/comments"
    HEAD    "/services/:id"
    POST    "/services/new"
    POST    "/services/:id/close"
    POST    "/services/:id/up"
    POST    "/services/:id/down"
    POST    "/services/:service_id/comments/new"
    PUT     "/services/:id"
    PUT     "/services/:service_id/comments/:id"
    DELETE  "/services/:service_id/comments/:id"

