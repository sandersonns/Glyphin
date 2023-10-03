require 'httparty'

class What3WordsService
  BASE_URL = 'https://api.what3words.com/v3'.freeze

  def initialize(api_key)
    @api_key = api_key
  end

  def coordinates_to_words(lat, lng)
    response = HTTParty.get("#{BASE_URL}/convert-to-3wa?coordinates=#{lat},#{lng}&key=#{@api_key}")
    response.parsed_response['words'] # Returns the 3-word address
  end

  def words_to_coordinates(words)
    response = HTTParty.get("#{BASE_URL}/convert-to-coordinates?words=#{words}&key=#{@api_key}")
    response.parsed_response['coordinates'] # Returns the latitude and longitude
  end

  def autosuggest(input)
    response = HTTParty.get("#{BASE_URL}/autosuggest?input=#{input}&key=#{@api_key}")
    response.parsed_response['suggestions'] # Returns the autosuggested 3-word addresses
  end
end
