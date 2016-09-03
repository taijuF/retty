# -*- coding: utf-8 -*-                                                                               
require "sinatra/base"

# トークンなど
CALLBACK_TOKEN = "hashikan.retty-token"

class App < Sinatra::Base
  # GETで来るのはコールバック検証                                                                     
  get "/" do
    if params["hub.verify_token"] == CALLBACK_TOKEN
      return params["hub.challenge"]
    end
    return ""
  end
end
