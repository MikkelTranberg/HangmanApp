defmodule Dictionary do

  @wordlist "assets/words.txt"
  |> File.read!()
  |> String.split()

  def random_word do
    @wordlist
    |> Enum.random()
  end
end

defmodule Lists do
  def len([]), do: 0
  def len([_h | t]), do: 1 + len(t)

  def sum([]), do: 0
  def sum([h | t]), do: h + sum(t)

  def square([]), do: []
  def square([h | t]), do: [h*h | square(t)]

  def sumOfTwo([]), do: []
  def sumOfTwo([h1, h2|t]), do: [h1 + h2 | sumOfTwo(t)]

  def even_length?([]), do: false
  def even_length?([_h1|[]]), do: false
  def even_length?([_h1,_h2|[]]), do: true
  def even_length?([_h1,_h2|t]), do: even_length?(t)





end
