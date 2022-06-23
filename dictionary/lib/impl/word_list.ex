defmodule Dictionary.Impl.WordList do

@type t :: [String.t]

@spec wordlist() :: t
def wordlist() do

  "../../assets/words.txt"
   |> Path.expand(__DIR__)
   |> File.read!()
  |> String.split( ~r/\n/, trim: true)

end

@spec random_word(t) :: String.t
  def random_word(wordlist) do
    wordlist |> Enum.random()

  end

end
