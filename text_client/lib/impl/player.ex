defmodule TextClient.Impl.Player do

  @typep game :: Hangman.game
  @typep tally :: Hangman.Type.tally
  @typep state :: {game, tally}

  @spec start(game) :: :ok
  def start(game) do


    tally = Hangman.tally(game)
    interact({game, tally})
  end

  @spec interact(state) :: :ok
  def interact({game, _tally = %{game_state: :won  }}) do
    IO.puts "congratulations. you won! The word was: #{game.letters}! "
  end

  def interact({_game, tally = %{game_state: :lost }}) do
    IO.puts "you lost! try again ... the word was: #{tally.letters |> Enum.join}"
  end

  def interact({game, tally}) do
    IO.puts (IO.ANSI.format([:blue, "-----------------------------"]))
    IO.puts feedback_for(tally)
    IO.puts current_word(tally)
    tally = Hangman.make_move(game, get_guess())
    interact({game, tally})
  end

  def feedback_for(tally = %{game_state: :initializing}) do
    "welcome im thinking about a word with #{tally.letters |> length} letters"
  end

  def feedback_for(_tally = %{game_state: :good_guess}), do: (IO.ANSI.format([:green, "good job"]))
  def feedback_for(_tally = %{game_state: :bad_guess}), do: (IO.ANSI.format([:red, "That letter was not in the word!"]))
  def feedback_for(_tally = %{game_state: :already_used}), do:  (IO.ANSI.format([:yellow, "you have already tried that letter, find another one"]))

  def current_word(tally) do
    "word: #{tally.letters |> Enum.join(" ")}
    Turns left: #{tally.turns_left}
    used so far: #{tally.used |> Enum.join(",")}"
  end

  def get_guess() do
    IO.gets("Next letter: ")
    |> String.trim()
    |> String.downcase()
  end


end
