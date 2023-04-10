class YouTubeSuccess

  def initialize(params = {})
    @video_ids = params[:video_ids]
    @current_index = 0
  end

  def code
    '200'
  end

  # rubocop:disable MethodLength
  def body
    { kind:          'youtube#searchListResponse',
      etag:          '\'XI7nbFXulYBIpL0ayR_gDh3eu1k/dnKFoHSwvM8Ke4E1rEFKXxFBaCQ\'',
      nextPageToken: 'CAEQAA',
      regionCode:    'UA',
      pageInfo:      { totalResults: 107444, resultsPerPage: 1 },
      items:         [{ kind:    'youtube#searchResult',
                        etag:    '\'XI7nbFXulYBIpL0ayR_gDh3eu1k/aFZofghqqGJVWP9ESlQ6rURvtGE\'',
                        id:      { kind: 'youtube#video', videoId: get_video_ids },
                        snippet: { publishedAt: '2008-01-18T17:14:22.000Z',
                        channelId: 'UCnWPG8zomaApVpVrwG5wjvQ',
                        title: 'Dima Bilan - Toska (Live)',
                        description: 'russian singer best singer.',
                        thumbnails: { default: { url:    'https://i.ytimg.com/vi/QyxdQDaVzb0/default.jpg',
                                                 width:  120,
                                                 height: 90 },
                                      medium:  { url:    'https://i.ytimg.com/vi/QyxdQDaVzb0/mqdefault.jpg',
                                                 width:  320,
                                                 height: 180 },
                                      high:    { url:    'https://i.ytimg.com/vi/QyxdQDaVzb0/hqdefault.jpg',
                                                 width:  480,
                                                 height: 360 } },
                        channelTitle: 'bilayn', liveBroadcastContent: 'none' } }] }.to_json
  end

  def headers
    {}
  end

  private

  def get_video_ids
    value = @video_ids.present? ? @video_ids[@current_index] : generate_video_id
    @current_index+=1
    value
  end

  def generate_video_id
    DateTime.current.strftime('%Y%m%H%M%s') + rand(9999).to_s
  end
end
