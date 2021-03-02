defmodule Poker do

  def generatorDeck() do generatorDeck([], 1) end
  defp generatorDeck(deck,54) do IO.inspect deck end
  defp generatorDeck(deck,curr) do
      if curr < 14 do
        deck = deck ++ ["#{curr}" <> "C"]
        generatorDeck(deck,curr+1)
      end
      if 13 < curr and curr < 27 do
        deck = deck ++ ["#{curr}" <> "D"]
        generatorDeck(deck,curr+1)
      end
      if 26 < curr and curr < 40 do
        deck = deck ++ ["#{curr}" <> "H"]
        generatorDeck(deck,curr+1)
      end
      if 39 < curr and curr < 54 do
        deck = deck ++ ["#{curr}" <> "S"]
        generatorDeck(deck,curr+1)
      end
  end

  def deal(deck) do
    deck
  end

  # def checkSuit(cards) do
  #   {num,suit} = String.split_at(List.first(cards), 1)
  #   Enum.filter(cards, fn card ->
  #     {Cnum,Csuit} = String.split_at(card, 1)
  #     Csuit == suit
  #   end)

  # end
  # def stringg do
  #   {a,b} = String.split_at("qc", 1)
  #   b
  # end
end


# Enum.each(0..10,
# fn(x) ->
#   deck= Map.put(deck, x, x)
#   IO.inspect deck
# end)
# deck
