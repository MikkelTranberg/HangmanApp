defmodule Hangman do

  alias Hangman.Runtime.Server
  alias Hangman.Type

  @opaque t :: Server.t
  @type tally :: Type.tally

  @spec new_game() :: t
  def new_game do
    {:ok, pid} = Hangman.Runtime.Application.start_game
    pid
  end



  @spec make_move(t, String.t) :: tally
  def make_move(pid, guess) do
    GenServer.call(pid, {:make_move, guess})
  end

@spec tally(t) :: tally
def tally(pid) do
  GenServer.call(pid, {:tally})
end


end
