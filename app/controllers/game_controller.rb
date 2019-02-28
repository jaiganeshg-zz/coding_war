class GameController < ApplicationController
  def login
    CodingWar.new.login
  end

  def move
    CodingWar.new.move(params.require(:direction))
  end

  def status
    CodingWar.new.status
  end

  def fire
    CodingWar.new.fire(params.require(:direction))
  end

  def place_bomb
    CodingWar.new.place_bomb
  end
end
