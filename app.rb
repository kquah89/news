require "sinatra"
require "sinatra/reloader"
require "httparty"
def view(template); erb template.to_sym; end

get "/" do
  ### Get the weather
  # Evanston, Kellogg Global Hub... replace with a different location if you want
  lat = 42.0574063
  long = -87.6722787

  units = "imperial"
  weatherkey = "9f35050b376e19c67d3ec6f8b2d75a3d"

  # construct the URL to get the API data (https://openweathermap.org/api/one-call-api)
  url = "https://api.openweathermap.org/data/2.5/onecall?lat=#{lat}&lon=#{long}&units=#{units}&appid=#{weatherkey}"
  @forecast = HTTParty.get(url).parsed_response.to_hash

  require 'date'
    
    @current = ["Today: We expect #{@forecast["current"]["weather"][0]["description"]} throughout the day. It is currently #{@forecast["current"]["temp"]} degrees, but feels like #{@forecast["current"]["feels_like"]} degrees"]

    extended = []
    no_of_days = 1
    for day in @forecast["daily"]
        extended << "Day #{no_of_days}: #{day["temp"]["day"]} degrees with a high of #{day["temp"]["max"]} degrees and a low of #{day["temp"]["min"]} degrees. #{day["weather"][0]["description"]} throughout the day"
        no_of_days = no_of_days + 1
    end

    @extendedweather = extended[0, 7]

  # Get the news

  newskey = "fee7c70010254ab7b3a5e69f3662b88a"
  url = "https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=#{newskey}"
  @businessnews = HTTParty.get(url).parsed_response.to_hash

    business_news = []
    news_number = 1
    for news in @businessnews["articles"]
        business_news << "#{news["url"]}>#{news_number}: #{news["title"]}" 
        news_number = news_number + 1
    end

    @topnews = business_news[0,5]




  # Get sports news

  url = "https://newsapi.org/v2/top-headlines?country=us&category=sports&apiKey=#{newskey}"
  @sportsnews = HTTParty.get(url).parsed_response.to_hash

    sports_news = []
    sports_news_number = 1
    for news in @sportsnews["articles"]
        sports_news << "#{news["url"]}>#{sports_news_number}: #{news["title"]}" 
        sports_news_number = sports_news_number + 1
    end

    @sportsnews = sports_news[0,5]

    view "news"
end
