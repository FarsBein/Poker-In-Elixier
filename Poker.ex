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
    condition = checkSuit(hand, (tl (hd hand)))
    if condition do
      IO.inspect hand
      royalFlush(hand)
      straightFlush(hand)
      [1,3,1] #next fun that handles suit should be here
    else
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

  def straightFlush([h|t]) do straightFlush(t, h, 0) end
  def straightFlush(_, _, 5) do IO.puts "Straight Flush"  end
  def straightFlush([], _, _) do IO.puts "Not Straight Flush" end
  def straightFlush([h|t], c, count) do
    case (hd h) == ((hd c)+1) do
      true -> straightFlush(t, h, count+1)
      _ -> straightFlush(t, h, 0)
    end
  end


end
