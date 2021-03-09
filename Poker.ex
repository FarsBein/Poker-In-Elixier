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

  def countUniqe(cards) do
    cardsV = valuesOnly(cards)
    reducedHand = Enum.reduce(cardsV, %{}, fn(key, dic) -> Map.update(dic, key, 1, &(&1 + 1)) end)
    Enum.filter(reducedHand, fn x -> x end)
  end

  def compare(handPool1, handPool2) do
    [hand1, hand1rank, tieBreaker1] = checkSuit handPool1
    [hand2, hand2rank, tieBreaker2] = checkSuit handPool2
    IO.inspect "Results --------------------------"
    if hand1rank < hand2rank do
      IO.inspect hand1
      IO.inspect hand1rank
    end

    if hand1rank > hand2rank do
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

  # checker ---------------------------------------------

  def checkSuit(hand) do
    IO.inspect hand
    royalFlush = royalFlush(hand)
    straightFlush = straightFlush(hand)
    fourOfKind = fourOfKind(hand)
    fullHouse = fullHouse(hand)
    flush = flush(hand)
    straight = straight(hand)
    threeOfKind = threeOfKind(hand)
    pairs = pairs(hand)
    highCards = highCards(hand)
    cond do
      (royalFlush != [0,0,0]) -> royalFlush
      (straightFlush != [0,0,0]) -> straightFlush
      (fourOfKind != [0,0,0]) -> fourOfKind
      (fullHouse != [0,0,0]) -> fullHouse
      (flush != [0,0,0]) -> flush
      (straight != [0,0,0]) -> straight
      (threeOfKind != [0,0,0]) -> threeOfKind
      (pairs != [0,0,0]) -> pairs
      (highCards != [0,0,0]) -> highCards
      true -> [0,11,0]
    end
  end

  def royalFlush([[1, s], _, _, [10, s], [11, s], [12, s], [13, s]]) do [[[10, s], [11, s], [12, s], [13, s], [1, s]],1,0] end
  def royalFlush(_) do [0,0,0] end

  def straightFlush([h|t]) do straightFlush(t, h, 1, [h]) end
  def straightFlush(_, _, 5, finalHand) do [finalHand,2,(hd (tl finalHand))] end
  def straightFlush([],_,_,_) do [0,0,0] end
  def straightFlush([h|t], c, count,finalHand) do
    case (hd h) == ((hd c)+1) do
      true -> straightFlush(t, h, count+1, finalHand ++ [h])
      _ -> straightFlush(t, h, 0, [])
    end
  end

  def fourOfKind([[c, s1], [c, s2], [c, s3], [c, s4],_,_,c5]) do [[[c, s1], [c, s2], [c, s3], [c, s4],c5],3,(hd c5)] end
  def fourOfKind([_,[c, s1], [c, s2], [c, s3], [c, s4],_,c5]) do [[[c, s1], [c, s2], [c, s3], [c, s4],c5],3,(hd c5)] end
  def fourOfKind([_,_,[c, s1], [c, s2], [c, s3], [c, s4],c5]) do [[[c, s1], [c, s2], [c, s3], [c, s4],c5],3,(hd c5)] end
  def fourOfKind([_,_,c5,[c, s1], [c, s2], [c, s3], [c, s4]]) do [[[c, s1], [c, s2], [c, s3], [c, s4],c5],3,(hd c5)] end
  def fourOfKind(_) do [0,0,0] end

  def fullHouse([h|t]) do fullHouse(t++[[0,0]], [h], [], []) end
  def fullHouse([], _, triple, pair) do
    unless (triple == [] or pair == []) do
      t1 = (hd Enum.reverse(triple))
      p1 = (hd pair)
      p2 =  (hd (tl pair))
      [triple ++ [p1,p2], 4, (hd t1)] # add the pair tie breaker
    else
      [0,0,0]
    end
  end
  def fullHouse(hand, tempList, triple, pair) do
    cardTemp = hd (hd tempList)
    card = (hd hand)
    cond do
      (hd card) == cardTemp -> fullHouse((tl hand), tempList ++ [card] , triple, pair)
      length(tempList) == 3 -> fullHouse((tl hand), [card], triple ++ tempList, pair)
      length(tempList) == 2 -> fullHouse((tl hand), [card], triple ,  tempList ++ pair )
      true -> fullHouse((tl hand), [card], triple, pair)
    end
  end

  def flush([[c1, s], [c2, s], [c3, s], [c4, s],[c5, s],_,_]) do [[[c1, s], [c2, s], [c3, s], [c4, s],[c5, s]], 5,c5] end
  def flush([_,[c1, s], [c2, s], [c3, s], [c4, s],[c5, s],_]) do [[[c1, s], [c2, s], [c3, s], [c4, s],[c5, s]], 5,c5] end
  def flush([_,_,[c1, s], [c2, s], [c3, s], [c4, s],[c5, s]]) do [[[c1, s], [c2, s], [c3, s], [c4, s],[c5, s]], 5,c5] end
  def flush(_) do [0,0,0] end

  def replace(hand, replace, newVal, remove) do
    if remove do
      newlist = Enum.filter(hand, fn ([c, _]) -> c != replace end)
      ones = Enum.filter(hand, fn ([c, _]) -> c == replace end)
      Enum.map(ones, fn ([_, suit]) -> [newVal,suit] end) ++ newlist
    else
      newlist = hand
      ones = Enum.filter(hand, fn ([c, _]) -> c == replace end)
      newlist ++ Enum.map(ones, fn ([_, suit]) -> [newVal,suit] end)
    end
  end
  def straight(hand) do
    hand = replace(hand, 1, 14, false)
    revHand = Enum.reverse(hand)
    straight((tl revHand), (hd revHand), 1,[(hd revHand)])
  end
  def straight(_, _, 5, winHand) do
    biggestCard = (hd (hd winHand))
    winHand = replace(winHand, 14, 1, true)
    [winHand, 6, biggestCard]
  end
  def straight([], _, _, _) do [0,0,0] end
  def straight([nextCard|t], currNum, count, winHand) do
    case (hd nextCard) == ((hd currNum)-1) do
      true -> straight(t, nextCard, count+1, winHand ++ [nextCard])
      _ -> straight(t, nextCard, 1, [nextCard])
    end
  end

  # add a second tie breaker
  def threeOfKind([_,_,c2,c1,[rank, s1], [rank, s2], [rank, s3]]) do [[[rank, s1], [rank, s2], [rank, s3],c2,c1], 7,rank] end
  def threeOfKind([_,_,c2,[rank, s1], [rank, s2], [rank, s3],c1]) do [[[rank, s1], [rank, s2], [rank, s3],c2,c1], 7,rank] end
  def threeOfKind([_,_,[rank, s1], [rank, s2], [rank, s3],c2,c1]) do [[[rank, s1], [rank, s2], [rank, s3],c2,c1], 7,rank] end
  def threeOfKind([_,[rank, s1], [rank, s2], [rank, s3],_,c2,c1]) do [[[rank, s1], [rank, s2], [rank, s3],c2,c1], 7,rank] end
  def threeOfKind([[rank, s1], [rank, s2], [rank, s3],_,_,c2,c1]) do [[[rank, s1], [rank, s2], [rank, s3],c2,c1], 7,rank] end
  def threeOfKind(_) do [0,0,0] end

  # add a second tie breaker
  def pairs(hand) do
    [head|tail] = Enum.reverse(hand)
    pairs(tail ++ [[0]], head, [head], [], []) end
  def pairs([], _, _, [p1,p2], nonPairsHolder) do
    IO.inspect([p1,p2])
    [c2,c3,c4,_,_,_] = nonPairsHolder
    [[p1,p2,c2,c3,c4], 9, (hd p1)]
  end
  def pairs([], _, _, [], _) do [0,0,0] end
  def pairs([], _, _, pairsHolder, nonPairsHolder) do
    IO.inspect(pairsHolder)
    p1 = hd pairsHolder
    p2 = hd (tl pairsHolder)
    p3 = hd (tl (tl pairsHolder))
    p4 = hd (tl (tl (tl pairsHolder)))
    c5 = hd nonPairsHolder
    [[p1,p2,p3,p4,c5], 8, (hd p1)]
  end
  def pairs([nextCard|tail], currCard, tempHolder, pairsHolder, nonPairsHolder) do
    valNextCard = hd nextCard
    valCurrCard = hd currCard
    if valNextCard == valCurrCard do
      pairs(tail, nextCard, tempHolder ++ [nextCard], pairsHolder, nonPairsHolder)
    else
      if length(tempHolder) == 2 do
        pairs(tail, nextCard, [nextCard], pairsHolder ++ tempHolder, nonPairsHolder)
      else
        pairs(tail, nextCard, [nextCard], pairsHolder, nonPairsHolder ++ tempHolder)
      end
    end
  end

  def highCards(hand) do
    [_,_,c5,c4,c3,c2,c1] = hand
    [c5,c4,c3,c2,c1]
  end
end
