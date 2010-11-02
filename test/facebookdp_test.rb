require 'rubygems'
require 'facebookdp'
require 'test/unit'

class FacebookdpTest < Test::Unit::TestCase
  # copy valid code here:
  ACCESS_CODE = '' 
  FACEBOOK_APP_ID = '' 
  FACEBOOK_APP_SECRET = '' 
  class << self
    def startup
      unless @oauth2_token
        @oauth2 ||= Facebookdp::OAuth.new(FACEBOOK_APP_ID, FACEBOOK_APP_SECRET , 'https://graph.facebook.com', 'http://localhost:3000/oauth2_consumers/facebook/callback')
        expected = "https://graph.facebook.com/oauth/authorize?client_id=#{FACEBOOK_APP_ID}&type=web_server&redirect_uri=http%3A%2F%2Flocalhost%3A3000%2Ffacebook%2Fcallback"
        begin
          @oauth2_token ||= @oauth2.get_access_token(ACCESS_CODE)
          @client = Facebookdp::Base.new(@oauth2_token)
        rescue
          #TODO: how to know if session is invalid and recover?
          puts "Copy the following url into your browser to get a valid access token: #{@oauth2.authorize_url}"
          raise
        end
      end
    end

    def shutdown
      # puts 'this runs once at end'
    end

    def oauth2_token
      @oauth2_token
    end

    def client
      @client
    end

    def suite
      mysuite = super
      def mysuite.run(*args)
        FacebookdpTest.startup()
        super
        FacebookdpTest.shutdown()
      end
      mysuite
    end
  end

  def setup
    # puts 'runs once before each test'
  end

  def teardown
    # puts 'runs once after each test'
  end

  def test_simple
    assert(true)
  end

  def test_get_my_account
    result = self.class.client.my_account
    assert_equal("Dave Paroulek", result['name'])
  end

  def test_get_friend_ids
    result = self.class.client.friend_ids_and_names
    assert_equal(159, result.size)
  end

  def test_get_friends
    result = self.class.client.friends
    assert_equal(159, result.size)
  end

  def test_get_friend_info
    result = self.class.client.friend_info(1500782)
    assert_equal(result['name'], "Michael Shafrir")
    assert_equal(result['first_name'], "Michael")
  end

  def test_get_friend_statuses
    result = self.class.client.friend_statuses(1500782, 1)
    assert_equal(1, result.size)
    assert_not_nil(result[0]['message'])
  end

  def test_get_my_picture
    expected = "http://graph.facebook.com/1388092492/picture"    
    result = self.class.client.my_picture_url
    assert_equal(expected,result)
  end

end
