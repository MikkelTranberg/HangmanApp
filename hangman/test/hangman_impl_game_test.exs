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

  test "a duplicate word is reported" do
    game = Hangman.Impl.Game.init_game
    {game, _tally} = Hangman.Impl.Game.make_move(game, "x")
    assert game.game_state != :already_used

    {game, _tally} = Hangman.Impl.Game.make_move(game, "y")
    assert game.game_state != :already_used

    {game, _tally} = Hangman.Impl.Game.make_move(game, "x")
    assert game.game_state == :already_used
  end
  test "we record letters used" do
    game = Hangman.Impl.Game.init_game
    {game, _tally} = Hangman.Impl.Game.make_move(game, "x")
    {game, _tally} = Hangman.Impl.Game.make_move(game, "y")
    {game, _tally} = Hangman.Impl.Game.make_move(game, "x")

    assert MapSet.equal?(game.used, MapSet.new(["x","y"]))
  end

  test "guessing a correct letter modifies state to good guess" do
    game = Hangman.Impl.Game.init_game("test")
    {_game, tally} = Hangman.Impl.Game.make_move(game, "s")
    assert tally.game_state == :good_guess

  end

  test "guessing a wrong letter modifies state to bad guess" do
    game = Hangman.Impl.Game.init_game("test")
    {game, tally} = Hangman.Impl.Game.make_move(game, "x")
    assert tally.game_state == :bad_guess

    {game, tally} = Hangman.Impl.Game.make_move(game, "s")
    assert tally.game_state == :good_guess

    {_game, tally} = Hangman.Impl.Game.make_move(game, "y")
    assert tally.game_state == :bad_guess


  end


  test "guessing a correct word modifies state to won" do
    game = Hangman.Impl.Game.init_game("test")
    {game, _tally} = Hangman.Impl.Game.make_move(game, "t")
    {game, _tally} = Hangman.Impl.Game.make_move(game, "e")
    {game, _tally} = Hangman.Impl.Game.make_move(game, "s")
    {game, _tally} = Hangman.Impl.Game.make_move(game, "t")
    {_game, tally} = Hangman.Impl.Game.make_move(game, "x")
    assert tally.game_state == :won

  end
  #hello
  test "can handle sequence of moves" do

  [
    #guess |state    | turnsleft   | letters            |used
    ["a", :bad_guess, 6,          ["_","_","_","_","_"],["a"]],
    ["a", :already_used, 6,          ["_","_","_","_","_"],["a"]],
    ["e", :good_guess, 6,          ["_","e","_","_","_"],["a","e"]],
    ["x", :bad_guess, 5,          ["_","e","_","_","_"],["a","e","x"]]

  ]
  |> test_sequence_of_moves()
  end

  test "can handle sequence of moves winning game" do

    [
      #guess |state    | turnsleft   | letters            |used
      ["a", :bad_guess,   6,          ["_","_","_","_","_"],["a"]],
      ["a", :already_used, 6,         ["_","_","_","_","_"],["a"]],
      ["e", :good_guess,  6,          ["_","e","_","_","_"],["a","e"]],
      ["h", :good_guess,  6,          ["h","e","_","_","_"],["a","e","h"]],
      ["l", :good_guess,  6,          ["h","e","l","l","_"],["a","e","h","l"]],
      ["x", :bad_guess,   5,          ["h","e","l","l","_"],["a","e","h","l","x"]],
      ["o", :won,         5,          ["h","e","l","l","o"],["a","e","h","l","o","x"]]


    ]
    |> test_sequence_of_moves()
    end

    test "can handle sequence of moves loosing game" do

      [
        #guess |state    | turnsleft   | letters            |used
        ["a", :bad_guess,   6,          ["_","_","_","_","_"],["a"]],
        ["a", :already_used, 6,         ["_","_","_","_","_"],["a"]],
        ["e", :good_guess,  6,          ["_","e","_","_","_"],["a","e"]],
        ["h", :good_guess,  6,          ["h","e","_","_","_"],["a","e","h"]],
        ["l", :good_guess,  6,          ["h","e","l","l","_"],["a","e","h","l"]],
        ["x", :bad_guess,   5,          ["h","e","l","l","_"],["a","e","h","l","x"]],
        ["b", :bad_guess,   4,          ["h","e","l","l","_"],["a","b","e","h","l","x"]],
        ["c", :bad_guess,   3,          ["h","e","l","l","_"],["a","b","c","e","h","l","x"]],
        ["d", :bad_guess,   2,          ["h","e","l","l","_"],["a","b","c","d","e","h","l","x"]],
        ["f", :bad_guess,   1,          ["h","e","l","l","_"],["a","b","c","d","e","f","h","l","x"]],
        ["g", :lost,        0,          ["h","e","l","l","o"],["a","b","c","d","e","f","g","h","l","x"]]
      ]
      |> test_sequence_of_moves()
      end

    defp test_sequence_of_moves(script) do
      game = Hangman.Impl.Game.init_game("hello")
      Enum.reduce(script, game, &check_one_move/2)
    end

    defp check_one_move([guess, state, turns_left, letters, used], game) do
      {game, tally} = Hangman.Impl.Game.make_move(game, guess)
      assert tally.game_state == state
      assert tally.turns_left == turns_left
      assert tally.letters == letters
      assert tally.used == used
      game
    end
end
