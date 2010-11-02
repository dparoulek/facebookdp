module Facebookdp
  class Base
    def initialize(oauth2_access_token)
      @access_token = oauth2_access_token
    end

    # 
    # Return current user's account information
    def my_account
      @my_account ||= Crack::JSON.parse(get_request("/me"))
    end

    def my_picture_url
      @my_picture_url ||= "http://graph.facebook.com/#{my_account['id']}/picture"
    end

    # Get list of hash's id and name keys for each of current_user's friends
    def friend_ids_and_names
      @friend_ids ||= Crack::JSON.parse(get_request("/me/friends?fields=id,name"))['data']
    end

    # Get all information about all your friends. Pass limit
    def friends(limit=0, offset=0)
      if(limit<=0)
        @friends ||= Crack::JSON.parse(get_request("/me/friends"))['data']
      else
        #TODO: this isn't working, not sure why
        @friends ||= Crack::JSON.parse(get_request("/me/friends?limit=#{limit}&offset=#{offset}"))['data']
      end
    end

    # Retrieve full information about a friend given their facebook id
    def friend_info(fbid)
      Crack::JSON.parse(get_request("/#{fbid}"))
    end

    # Retrieve last 10 statuses of a friend. Pass in limit to control
    # number of status returned
    def friend_statuses(fbid, limit=10)
      Crack::JSON.parse(get_request("/#{fbid}/statuses?limit=#{limit}"))['data']
    end

    # Retrieve all statuses published by a friend since the date specified.
    # TODO: not tested yet
    def friend_latest_statuses(unix_timestamp)
      Crack::JSON.parse(get_request("/#{fbid}/statuses?since=#{unix_timestamp}"))
    end

    protected

    def get_request(path)
      @access_token.get(path)
    end

  end
end
