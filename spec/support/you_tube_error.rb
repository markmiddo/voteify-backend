class YouTubeError

  def code
    '400'
  end

  def body
    { error: {
        errors:  [
            { domain: 'usageLimits', reason: 'keyInvalid', message: 'Bad Request' }
        ],
        code:    400,
        message: 'Bad Request' } }.to_json
  end

  def headers
    {}
  end
end
