def translate(cards) do
  deck = generatorDeck()
  IO.inspect deck
  translate(cards, deck, [])
end
defp translate([], _, finalCards) do finalCards end
defp translate([head | tail], deck, finalCards) do
  translate([], deck, finalCards)
end

testing = fn a -> "not" <> a end
def testReturn() do
  T = testReturn(fn a -> "not" <> a end)
  IO.puts T
end
def testReturn(testing) do testing.("cool") end


def generatorDeck(cards) do generatorDeck([], 1,cards) end
defp generatorDeck(deck,54,cards) do translate(cards,deck) end
defp generatorDeck(deck,curr,cards) do
    if curr < 14 do
      deck = deck ++ ["#{curr}" <> "C"]
      generatorDeck(deck,curr+1,cards)
    end
    if 13 < curr and curr < 27 do
      deck = deck ++ ["#{curr-13}" <> "D"]
      generatorDeck(deck,curr+1,cards)
    end
    if 26 < curr and curr < 40 do
      deck = deck ++ ["#{curr-26}" <> "H"]
      generatorDeck(deck,curr+1,cards)
    end
    if 39 < curr and curr < 54 do
      deck = deck ++ ["#{curr-39}" <> "S"]
      generatorDeck(deck,curr+1,cards)
    end
end
