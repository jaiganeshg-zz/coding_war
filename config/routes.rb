Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post '/game/login', to: 'game#login'
  post '/game/move', to: 'game#move'
  post '/game/fire', to: 'game#fire'
  post '/game/place_bomb', to: 'game#place_bomb'
  get '/game/status', to: 'game#status'
end
