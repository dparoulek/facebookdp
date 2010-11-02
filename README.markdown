# Overview

This gem allows you to authenticate against facebook and then make Graph API calls from ruby

# Authenticating a user against Facebook to obtain an access\_token

The goal here is to delegate authentication to Facebook and retrieve a
secret OAuth2 `access_token`. In other words, you want your web
application to be able to send a user to facebook, and have facebook
figure out whether or not they are who they say they are.

Facebook uses OAuth2 to authenticate users on thirdparty application's
behalf. This gem handles the Oauth2 "handshake" with
facebook. Basically, here are the steps:

1) Register you application with Facebook and get your API Key and API Secret

2) Create Facebook::OAuth object like so: 

    @oauth2 ||= Facebookdp::OAuth.new(your-api-key, you-api-secret, 'https://graph.facebook.com', facebook-callback-url)
    
The `facebook-callback-url` argument should be something like
`http://yourwebapp/facebook-controller/handle-facebook-response`. If
you don't specifiy a facebook-callback-url, it will default to
`http://localhost:3000/facebook`. So you might want to just stick a
controller there when doing development for easy testing.

3) Next, call `@oauth2.authorize_url`. This should give you a url like
this:
`https://graph.facebook.com/oauth/authorize?client_id=YOUR_APP_ID&type=web_server&redirect_uri=http%3A%2F%2Flocalhost%3A3000%2Ffacebook%2Fcallback`

4) Now it's time to trade the `client_id` for a Access Token (note the
http param named `client_id` in the `authorize_url`). Your web app
should redirect the user's browser to the `authorize_url`. Facebook
then prompts for a username and password. The user enters a username
and password.

Tip: During development, sometimes it helps to simply copy and paste the `authorize_url` into your
browser. 

5a) If the user enters invalid credentials, they'll be redirected back
to the `facebook-callback-url` specified above. The request will
include a http param named `error_reason` so your application can
handle the invalid username and password error appropriately.

5b) If this is the first time the user has ever logged into your
application, they'll be prompted by Facebook whether to allow or deny
your web application. After they choose to allow or deny, they'll be
redirected to the facebook-callback-url specified above. 

6) Assuming the user entered correct credentials and approved your web
application, then they'll be redirected back to the
`facebook-callback-url` you specified above. For example, something like this

http://yourwebapp/facebook-controller/handle-facebook-response?code=dd8490a3a1c82de377f45bc3-1388092492|\_6MST-8QGIQhiKP3ZkdEMou44Uo

Your web appilcation should parse that access code and hang onto it!

7) Next, you trade the access code for an `access_token` like so: 

    @oauth2_token = @oath2.get_access_token
    @oauth2_token ||= @oauth2.get_access_token(the-access-code-you-parsed-and-saved)

# Using this Facebook Gem to make Graph API calls

First, you have to do the whole OAuth2 song and dance as described above. Once you do that, you should have a OAuth2 `access_token` for the user. You can then use the token to create an instance of the Facebookdp::Base class. 

    @client = Facebookdp::Base.new(@oauth2_token)
    
Then, simply use the `@client` instance to make Facebook Graph API
calls on the user's behalf. For example, you can get all the users
friends:

    friends = @client.friends
    

