class GameController < ApplicationController
  rescue_from ::Exception, with: :status
  def login
    CodingWarClient.new.login
    render :board
  end

  def move
    CodingWarClient.new.move(params.require(:direction))
    render :board
  end

  def status
    CodingWarClient.new.status
    render :board
  end

  def home
    render :board
  end

  def fire
    CodingWarClient.new.fire(params.require(:direction))
    render :board
  end

  def place_bomb
    CodingWarClient.new.place_bomb
    render :board
  end
end
