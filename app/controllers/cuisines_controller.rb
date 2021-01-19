require 'dotenv'
require 'json'
Dotenv.load

class CuisinesController < ApplicationController

  def cuisines
   @response =  RestClient.get "https://developers.zomato.com/api/v2.1/cities?q=#{params["city"]}",
    {content_type: :json, accept: :json, "user-key": ENV["API_KEY"]}
 
   @city_info = JSON.parse(@response.body)["location_suggestions"][0]
    
   if @city_info
     @cuisines = RestClient.get "https://developers.zomato.com/api/v2.1/cuisines?city_id=#{@city_info["id"]}", 
     {content_type: :json, accept: :json, "user-key": ENV["API_KEY"]}

     @city_info["cuisines"] = JSON.parse(@cuisines.body)["cuisines"]

     render json: @city_info
   else
     render json: {message: "City Not Found", error: 404}
   end
  end
 end
end ##end of class