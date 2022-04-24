defmodule HangmanImplGameTest do
  use ExUnit.Case
  doctest Hangman

  test "new game returns a proper game" do
    game = Hangman.Impl.Game.init_game
    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert length(game.letters) > 0
  end

  test "new game returns correct word" do

    game = Hangman.Impl.Game.init_game("test")

    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert length(game.letters) > 0
    assert game.letters == ["t","e","s","t"]
  end


  test "is each element of word a ASCII character lowercase" do
    game = Hangman.Impl.Game.init_game
    assert  true == Enum.all?(game.letters, fn x -> is_binary(x) == true end)
  end


  test "make move on a won game returns
  a game with won or lost state" do

    for state <- [:won, :lost] do
      game = Hangman.Impl.Game.init_game("test")
      game = Map.put(game, :game_state, state)
      {new_game, _tally} = Hangman.Impl.Game.make_move(game, "x")
      assert new_game == game
    end

  end


end
