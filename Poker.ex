defmodule Poker do

  def deal(cards) do translate(cards) end
  defp deal([], hand1, hand2, pool) do
    compare(Enum.sort(hand1 ++ pool), Enum.sort(hand2 ++ pool))
  end
  defp deal([head | tail], hand1, hand2, _) do
    if length(hand1) < 1 do
      hand2 = [hd tail]
      tail = tl tail
      deal(tail, [head], hand2, [])
    else
      deal([], (hand1 ++ [head]), (hand2 ++ [hd tail]), tl tail)
    end
  end

  def translate(cards) do translate(cards, []) end
  defp translate([], tranCards) do deal(tranCards, [], [], []) end
  defp translate([head | tail], tranCards) do
      if head < 14 do
        tranCards = tranCards ++ [[head, "C"]]
        translate(tail,tranCards)
      end
      if 13 < head and head < 27 do
        tranCards = tranCards ++ [[head-13, "D"]]
        translate(tail,tranCards)
      end
      if 26 < head and head < 40 do
        tranCards = tranCards ++ [[head-26, "H"]]
        translate(tail,tranCards)
      end
      if 39 < head and head < 54 do
        tranCards = tranCards ++ [[head-39, "S"]]
        translate(tail,tranCards)
      end
  end

  def valuesOnly(cards) do valuesOnly(cards,[]) end
  def valuesOnly([],finalCards) do finalCards end
  def valuesOnly([head|tail],finalCards) do
    valuesOnly(tail,finalCards ++ [ (hd head) ])
  end

  def compare(handPool1, handPool2) do
    [hand1, hand1rank, tieBreaker1] = checkSuit handPool1
    [hand2, hand2rank, tieBreaker2] = checkSuit handPool2

    if hand1rank > hand2rank do
      IO.inspect hand1
      IO.inspect hand1rank
    end

    if hand1rank < hand2rank do
      IO.inspect hand2
      IO.inspect hand2rank
    end

    if hand1rank == hand2rank do
      if tieBreaker1 > tieBreaker2 do
        IO.inspect hand1
        IO.inspect hand1rank
        IO.inspect tieBreaker1
      end
      if tieBreaker1 < tieBreaker2 do
        IO.inspect hand2
        IO.inspect hand2rank
        IO.inspect tieBreaker2
      end
    end

  end

  def checkSuit(hand) do
    IO.inspect hand
    condition = checkSuit(hand, (tl (hd hand)))
    IO.puts condition
    if condition do
      # royalFlush(hand)
      # straightFlush(hand)
      flush(hand)
      [1,3,1] #next fun that handles suit should be here
    else
      # fourOfKind(hand)
      # fullHouse(hand)
      # straight(hand)
      threeOfKind(hand)
      [hand,3,(hd (hd hand))] #next fun that handles non-suit should be here
    end
  end
  defp checkSuit([h | t], suit) do
    if (tl h) == suit do
      checkSuit(t, suit)
    else
      false
    end
  end
  defp checkSuit([],_) do true end

  def royalFlush([[1, _], _, _, [10, _], [11, _], [12, _], [13, _]]) do IO.puts "Royal Flush" end
  def royalFlush(_) do IO.puts "Not Royal Flush" end

  def straightFlush([h|t]) do straightFlush(t, h, 1) end
  def straightFlush(_, _, 5) do IO.puts "Straight Flush"  end
  def straightFlush([], _, _) do IO.puts "Not Straight Flush" end
  def straightFlush([h|t], c, count) do
    case (hd h) == ((hd c)+1) do
      true -> straightFlush(t, h, count+1)
      _ -> straightFlush(t, h, 0)
    end
  end

  def fourOfKind([[c, _], [c, _], [c, _], [c, _],_,_,_]) do IO.puts "Four of a kind" end
  def fourOfKind([_,[c, _], [c, _], [c, _], [c, _],_,_]) do IO.puts "Four of a kind" end
  def fourOfKind([_,_,[c, _], [c, _], [c, _], [c, _],_]) do IO.puts "Four of a kind" end
  def fourOfKind([_,_,_,[c, _], [c, _], [c, _], [c, _]]) do IO.puts "Four of a kind" end
  def fourOfKind(_) do IO.puts "Not Four of a kind" end

  def fullHouse(hand) do
    handV = valuesOnly(hand)
    reducedHand = Enum.reduce(handV, %{}, fn(key, dic) -> Map.update(dic, key, 1, &(&1 + 1)) end)
    reducedHandList = Enum.filter(reducedHand, fn x -> x end)
    fullHouse(reducedHandList, false, false)
  end
  def fullHouse([], passTriple, passPair) do
    if (passTriple and passPair) do
      IO.puts "Full House"
    else
      IO.puts "Not Full House"
    end
  end
  def fullHouse([head|tail], passTriple, passPair) do
    {_, count} = head
    if count == 3 do
      fullHouse(tail, true, passPair)
    end
    if count == 2 do
      fullHouse(tail, passTriple, true)
    end
    if count != 3 and count != 2  do
      fullHouse(tail, passTriple, passPair)
    end
  end

  def flush([[_, s], [_, s], [_, s], [_, s],[_, s],_,_]) do IO.puts "flush" end
  def flush([_,[_, s], [_, s], [_, s], [_, s],[_, s],_]) do IO.puts "flush" end
  def flush([_,_,[_, s], [_, s], [_, s], [_, s],[_, s]]) do IO.puts "flush" end
  def flush(_) do IO.puts "Not flush" end

  # merge with straight flush and rename it as sequence
  def straight([h|t]) do straight(t, h, 1) end
  def straight(_, _, 5) do IO.puts "Straight"  end
  def straight([], _, _) do IO.puts "Not Straight" end
  def straight([head|t], rightNum, count) do
    case (hd head) == ((hd rightNum)+1) do
      true -> straight(t, head, count+1)
      _ -> straight(t, rightNum, count)
    end
  end

  def threeOfKind(hand) do
    handV = valuesOnly(hand)
    reducedHand = Enum.reduce(handV, %{}, fn(key, dic) -> Map.update(dic, key, 1, &(&1 + 1)) end)
    reducedHandList = Enum.filter(reducedHand, fn x -> x end)
    threeOfKind(reducedHandList, false)
  end
  def threeOfKind(_, true) do IO.puts "Three of a Kind" end
  def threeOfKind([], _) do IO.puts "Not Three of a Kind" end
  def threeOfKind([head|tail], passTriple) do
    {_, count} = head
    if count == 3 do
      threeOfKind(tail, true)
    else
      threeOfKind(tail, passTriple)
    end
  end
end
