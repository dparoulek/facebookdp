module Facebookdp
  class OAuth
    attr_accessor :apikey, :apisecret, :graph_api_url, :callback_url, :code

    def initialize(apikey, apisecret, graph_api_url = "https://graph.facebook.com", callback_url = "http://localhost:3000/facebook/callback")
      @apikey = apikey
      @apisecret = apisecret
      @graph_api_url = graph_api_url
      @callback_url = callback_url
    end

    #
    # client is an instance of an oauth object, but needs to be
    # authenticated by having a user visit facebook and retrieve a
    # access code
    def client
      @client ||= OAuth2::Client.new(@apikey, @apisecret, :site => @graph_api_url)
    end

    #
    # Get the url needed to recieve auth token
    # behind the scenes, oauth2 is passing id and secret
    def authorize_url
      client.web_server.authorize_url( :redirect_uri => callback_url )
    end

    #
    # Create access_token, and then we're connected
    def get_access_token(code)
      @code = code
      @access_token ||= client.web_server.get_access_token( @code, :redirect_uri => callback_url)
    end

  end
end
