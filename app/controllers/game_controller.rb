class GameController < ApplicationController
  def login
    @board_state = CodingWarClient.new.login
    render :board
  end

  def move
    @board_state = CodingWarClient.new.move(params.require(:direction))
    render :board
  end

  def status
    @board_state = CodingWarClient.new.status
    render :board
  end

  def home
    render :board
  end

  def fire
    @board_state = CodingWarClient.new.fire(params.require(:direction))
    render :board
  end

  def place_bomb
    @board_state = CodingWarClient.new.place_bomb
    render :board
  end
end
