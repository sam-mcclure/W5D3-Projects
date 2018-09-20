require 'json'

class Session
  # find the cookie for this app
  # deserialize the cookie into a hash
  def initialize(req)
    @cookie = req.cookies["_rails_lite_app"]
    if @cookie # != nil
     @cookie = JSON.parse(@cookie)
     # req.cookies["_rails_lite_app"]
    else
      @cookie = {}
    end
  end

  def [](key)
    @cookie[key]
  end

  def []=(key, val)
    @cookie[key] = val
  end

  # serialize the hash into json and save in a cookie
  # add to the responses cookies
  def store_session(res)
    if @cookie
        res.set_cookie("_rails_lite_app", {path: "/" , value: @cookie.to_json})
    else
       puts "THE SHARK IS NOT WORKING"
    end
  end
end
