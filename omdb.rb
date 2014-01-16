require 'sinatra'
require 'sinatra/reloader'
require 'typhoeus'
require 'json'

get '/' do
  html = %q(
  <html><head><title>Movie Search</title></head><body>
  <h1>Find a Movie!</h1>
  <form accept-charset="UTF-8" action="/result" method="post">
    <label for="movie">Search for:</label>
    <input id="movie" name="movie" type="text" />
    <input name="commit" type="submit" value="Search" /> 
  </form></body></html>
  )
end

post '/result' do
  search_str = params[:movie]

  # Make a request to the omdb api here!

response = Typhoeus.get("www.omdbapi.com/", :params => {:s => search_str})
result = JSON.parse(response.body)["Search"]


# result.["Animals"].each {|a| puts "#{a["name"]} - #{a["age"]} years old"}

# puts response.body
  


  # Modify the html output so that a list of movies is provided.
  html_str = "<html><head><title>Movie Search Results</title></head><body><h1>Movie Results</h1>\n<ul>"
 #for each 
  result.each { |m| 
  
    html_str += "<li> #{m["Title"]} - #{m["Year"]} </li>"
  
  }

  html_str += "</ul></body></html>"

end

get '/poster/:imdb' do |imdb_id|
  response = Typhoeus.get("www.omdbapi.com/", :params => {:i => imdb_id})
  result= JSON.parse(response.body)["Poster"]
  # Make another api call here to get the url of the poster.
  html_str = "<html><head><title>Movie Poster</title></head><body><h1>Movie Poster</h1>\n"

  html_str = "<img src= #{result}>"
  html_str += '<br /><a href="/">New Search</a></body></html>'

end

