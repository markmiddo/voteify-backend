class YouTube
  API_KEY = ENV['YOUTUBE_API_KEY']
  API_URL = 'https://www.googleapis.com/youtube/v3'

  class << self
    def search(query)
      query = { q: query }.to_query
      uri = URI.parse("#{API_URL}/search?part=snippet&type=video&maxResults=1&#{query}&key=#{API_KEY}")
      http = Net::HTTP.new(uri.host,uri.port)
      http.use_ssl = true
      responce = http_get(http, uri)
      logger = Logger.new("#{Rails.root}/log/youtube.log")
      logger.debug "Youtube response code#{responce.code}"
      if responce.code == '200'
        JSON.parse(responce.body)['items'][0]
      else
        message = JSON.parse(responce.body).dig('error', 'message')
        raise BadRequestError.new("YouTube: #{message}")
      end
    end

    private

    def http_get(http, uri)
      begin
        http.get(uri.request_uri)
      rescue Net::OpenTimeout => error
        raise BadRequestError.new("YouTube: #{error}")
      end
    end
  end
end
