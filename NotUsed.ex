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


def fullHouse(hand) do
  fullHouse(hand, countUniqe(hand), [], [])
end
def fullHouse(_,[], triple, pair) do
  unless (triple == [] or pair == []) do
    t1 = (hd Enum.reverse(triple))
    p1 = (hd Enum.reverse(pair))
    p2 =  (hd (tl Enum.reverse(pair)))
    [triple ++ [p1,p2], 4, (hd t1)] # add the pair tie breaker
  else
    [0,0,0]
  end
end
def fullHouse([card|theRest],[head|tail], triple, pair) do
  {_, count} = head
  if count == 3 do
    triple2 = (hd theRest)
    triple3 = (hd (tl theRest))
    afterTriple = (tl (tl theRest))
    fullHouse(afterTriple, tail, triple ++ [card]++ [triple2]++ [triple3], pair)
  end
  if count == 2 do
    pair2 = (hd theRest)
    afterPair = (tl theRest)
    fullHouse(afterPair, tail, triple, pair  ++ [card] ++ [pair2])
  end
  if count != 3 and count != 2  do
    fullHouse(theRest, tail, triple, pair)
  end
end
