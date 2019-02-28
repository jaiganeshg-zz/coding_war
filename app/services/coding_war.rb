class CodingWar < ApiClient
  @username = 'swiss_knife'
  @secret = 'swiss_knife'
  BASE_URL = 'http://demo7524716.mockable.io/'
  @@server_secret = nil
  @@board_state = nil
  UP = 'UP'
  DOWN = 'DOWN'
  LEFT = 'LEFT'
  RIGHT = 'RIGHT'

  def login
    url = build_url('/login')
    payload = {secret: @secret, username: @username}
    response = api_call(:post, url, { header: DEFAULT_HEADERS, body: payload.to_json }, true)
    @@server_secret = response[:body]['usersecret']
  end

  def move(direction)
    url = build_url('/move')
    payload = {secret: @secret,
               username: @username,
               usersecret: @@server_secret,
               direction: direction
    }
    response = api_call(:post, url, { header: DEFAULT_HEADERS, body: payload.to_json }, true)
    @@board_state = response[:body]
  end

  def status
    url = build_url("/status/#{@secret}")
    response = api_call(:get, url, { header: DEFAULT_HEADERS }, true)
    @@board_state = response[:body]
  end

  def fire(direction)
    url = build_url('/fire')
    payload = {secret: @secret,
               username: @username,
               usersecret: @@server_secret,
               direction: direction
    }
    response = api_call(:post, url, { header: DEFAULT_HEADERS, body: payload.to_json }, true)
    @@board_state = response[:body]
  end

  def place_bomb
    url = build_url('/place_bomb')
    payload = {secret: @secret,
               username: @username,
               usersecret: @@server_secret
    }
    response = api_call(:post, url, { header: DEFAULT_HEADERS, body: payload.to_json }, true)
    @@board_state = response[:body]
  end

  private
  def build_url(path)
    URI.join(BASE_URL, path).to_s
  end
end