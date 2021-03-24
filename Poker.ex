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

  def translate(cards) do
    translate(cards, [])
  end
  defp translate([], tranCards) do deal(tranCards, [], [], []) end
  defp translate([head | tail], tranCards) do
      clubs = tranCards ++ [[head, "C"]]
      diamonds = tranCards ++ [[head-13, "D"]]
      hearts = tranCards ++ [[head-26, "H"]]
      spades = tranCards ++ [[head-39, "S"]]

      cond do
        head < 14 -> translate(tail,clubs)
        13 < head and head < 27 -> translate(tail,diamonds)
        26 < head and head < 40 -> translate(tail,hearts)
        39 < head and head < 54 -> translate(tail,spades)
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
    [[c1hand1,s1hand1],[c2hand1,s2hand1],[c3hand1,s3hand1],[c4hand1,s4hand1],[c5hand1,s5hand1]] = hand1
    [[c1hand2,s1hand2],[c2hand2,s2hand2],[c3hand2,s3hand2],[c4hand2,s4hand2],[c5hand2,s5hand2]] = hand2
    x = tieBreaker(tieBreaker1, tieBreaker2)
    finalHand1 = ["#{c1hand1}#{s1hand1}","#{c2hand1}#{s2hand1}","#{c3hand1}#{s3hand1}","#{c4hand1}#{s4hand1}","#{c5hand1}#{s5hand1}"]
    finalHand2 = ["#{c1hand2}#{s1hand2}","#{c2hand2}#{s2hand2}","#{c3hand2}#{s3hand2}","#{c4hand2}#{s4hand2}","#{c5hand2}#{s5hand2}"]

    cond do
      hand1rank < hand2rank -> finalHand1
      hand1rank > hand2rank -> finalHand2
      (x == 1 or x == 0) -> finalHand1
      x == 2 -> finalHand2
    end
  end

  def tieBreaker(tieBreaker1, tieBreaker2) when (tieBreaker1 != [] and tieBreaker2 != []) do
    [head1|t1] = tieBreaker1
    [head2|t2] = tieBreaker2
    cond do
      head1 > head2 -> 1
      head1 < head2 -> 2
      true -> tieBreaker(t1, t2)
    end
  end
  def tieBreaker(_, []) do
    1
  end
  def tieBreaker([], _) do
    2
  end
  # checker ---------------------------------------------

  def checkSuit(hand) do
    royalFlush = royalFlush(hand)
    straightFlush = straightFlush(hand)
    fourOfKind = fourOfKind(hand)
    fullHouse = fullHouse(hand)
    flush = flush(replace(hand, 1, 14, true))
    straight = straight(hand)
    threeOfKind = threeOfKind(hand)
    pairs = pairs(hand)
    highCards = highCards(hand)
    cond do
      (royalFlush != [0,0,0])   -> royalFlush
      (straightFlush != [0,0,0])-> straightFlush
      (fourOfKind != [0,0,0])   -> fourOfKind
      (fullHouse != [0,0,0])    -> fullHouse
      (flush != [0,0,0])        -> flush
      (straight != [0,0,0])     -> straight
      (threeOfKind != [0,0,0])  -> threeOfKind
      (pairs != [0,0,0])        -> pairs
      (highCards != [0,0,0])    -> highCards
      true -> [0,11,0]
    end
  end

  def royalFlush([[1, s], _, _, [10, s], [11, s], [12, s], [13, s]]) do [[[10, s], [11, s], [12, s], [13, s], [1, s]],1,[100]] end
  def royalFlush(_) do [0,0,0] end

  def straightFlush(hand) do
    [h|t] = Enum.reverse hand
    straightFlush(t, h, 1, [h]) end
  def straightFlush(_, _, 5, finalHand) do
    revFinalHand = Enum.reverse finalHand
    [revFinalHand,2, finalHand] end
  def straightFlush([],_,_,_) do [0,0,0] end
  def straightFlush([nextCard|t], currCard, count,finalHand) do
    nextCardVal = (hd nextCard)
    currCardVal = (hd currCard)
    nextCardSuit = (hd (tl nextCard))
    currCardSuit = (hd (tl currCard))

    case ((nextCardVal == (currCardVal-1)) and (nextCardSuit == currCardSuit)) do
      true -> straightFlush(t, nextCard, count+1, finalHand ++ [nextCard])
      _ -> straightFlush(t, nextCard, 1, [nextCard])
    end
  end

  def fourOfKind([_,_,c5,[c, s1], [c, s2], [c, s3], [c, s4]]) do [[[c, s1], [c, s2], [c, s3], [c, s4],c5],3, [c, (hd c5)]] end
  def fourOfKind([_,_,[c, s1], [c, s2], [c, s3], [c, s4],c5]) do [[[c, s1], [c, s2], [c, s3], [c, s4],c5],3, [c, (hd c5)]] end
  def fourOfKind([_,[c, s1], [c, s2], [c, s3], [c, s4],_,c5]) do [[[c, s1], [c, s2], [c, s3], [c, s4],c5],3, [c, (hd c5)]] end
  def fourOfKind([[c, s1], [c, s2], [c, s3], [c, s4],_,_,c5]) do [[[c, s1], [c, s2], [c, s3], [c, s4],c5],3, [c, (hd c5)]] end
  def fourOfKind(_) do [0,0,0] end

  def fullHouse(hand) do
    hand = replace(hand, 1, 14, false)
    [h|t] = Enum.reverse(hand)
    fullHouse(t++[[0,0]], [h], [], []) end
  def fullHouse([], _, triple, pair) do
    unless (triple == [] or pair == []) do
      t1 = (hd triple)
      p1 = (hd pair)
      p2 =  (hd (tl pair))
      winningHand = replace((triple ++ [p1,p2]),14, 1, true)
      [winningHand, 4, [(hd t1),(hd p1)]]
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
      length(tempList) == 2 -> fullHouse((tl hand), [card], triple ,  pair ++ tempList)
      true -> fullHouse((tl hand), [card], triple, pair)
    end
  end

  def flush(hand) do
    hand = Enum.reverse(hand)
    sFlush = Enum.filter(hand, fn ([_,suit]) -> suit == "S" end)
    hFlush = Enum.filter(hand, fn ([_,suit]) -> suit == "H" end)
    dFlush = Enum.filter(hand, fn ([_,suit]) -> suit == "D" end)
    cFlush = Enum.filter(hand, fn ([_,suit]) -> suit == "C" end)
    cond do
      length(sFlush) >= 5 -> [replace(Enum.slice(sFlush, 0, 5), 14, 1, true), 5, valuesOnly(sFlush)]
      length(hFlush) >= 5 -> [replace(Enum.slice(hFlush, 0, 5), 14, 1, true), 5, valuesOnly(hFlush)]
      length(dFlush) >= 5 -> [replace(Enum.slice(dFlush, 0, 5), 14, 1, true), 5, valuesOnly(dFlush)]
      length(cFlush) >= 5 -> [replace(Enum.slice(cFlush, 0, 5), 14, 1, true), 5, valuesOnly(cFlush)]
      true -> [0,0,0]
    end
  end

  def replace(hand, replace, newVal, remove) do
    if remove do
      newlist = Enum.filter(hand, fn ([c, _]) -> c != replace end)
      ones = Enum.filter(hand, fn ([c, _]) -> c == replace end)
      newlist ++ Enum.map(ones, fn ([_, suit]) -> [newVal,suit] end)
    else
      ones = Enum.filter(hand, fn ([c, _]) -> c == replace end)
      hand ++ Enum.map(ones, fn ([_, suit]) -> [newVal,suit] end)
    end
  end
  def straight(hand) do
    hand = replace(hand, 1, 14, false)
    revHand = Enum.reverse(hand)
    straight((tl revHand), (hd revHand), 1,[(hd revHand)])
  end
  def straight(_, _, 5, winHand) do
    [[c1,_],[c2,_],[c3,_],[c4,_],[c5,_]] = winHand
    winHand = replace(winHand, 14, 1, true)
    [winHand, 6, [c1,c2,c3,c4,c5]]
  end
  def straight([], _, _, _) do [0,0,0] end
  def straight([nextCard|t], currNum, count, winHand) do
    case (hd nextCard) == ((hd currNum)-1) do
      true -> straight(t, nextCard, count+1, winHand ++ [nextCard])
      _ -> straight(t, nextCard, 1, [nextCard])
    end
  end

  # add a second tie breaker
  def threeOfKind([_,_,c2,c1,[rank, s1], [rank, s2], [rank, s3]]) do [[[rank, s1], [rank, s2], [rank, s3],c2,c1], 7,[rank, (hd c1), (hd c2)]] end
  def threeOfKind([_,_,c2,[rank, s1], [rank, s2], [rank, s3],c1]) do [[[rank, s1], [rank, s2], [rank, s3],c2,c1], 7,[rank, (hd c1), (hd c2)]] end
  def threeOfKind([_,_,[rank, s1], [rank, s2], [rank, s3],c2,c1]) do [[[rank, s1], [rank, s2], [rank, s3],c2,c1], 7,[rank, (hd c1), (hd c2)]] end
  def threeOfKind([_,[rank, s1], [rank, s2], [rank, s3],_,c2,c1]) do [[[rank, s1], [rank, s2], [rank, s3],c2,c1], 7,[rank, (hd c1), (hd c2)]] end
  def threeOfKind([[rank, s1], [rank, s2], [rank, s3],_,_,c2,c1]) do [[[rank, s1], [rank, s2], [rank, s3],c2,c1], 7,[rank, (hd c1), (hd c2)]] end
  def threeOfKind(_) do [0,0,0] end

  # add a second tie breaker
  def pairs(hand) do
    hand = replace(hand, 1, 14, true)
    [head|tail] = Enum.reverse(hand)
    pairs(tail ++ [[0]], head, [head], [], []) end
  def pairs([], _, _, [p1,p2], nonPairsHolder) do
    biggestPair = (hd p1)
    [p1,p2] = replace([p1,p2], 14, 1, true)
    nonPairsHolder = replace(nonPairsHolder, 14, 1, true)
    [c2,c3,c4,_,_] = nonPairsHolder
    [[p1,p2,c2,c3,c4], 9, [biggestPair, (hd c2), (hd c3)]]
  end
  def pairs([], _, _, [], _) do [0,0,0] end
  def pairs([], _, _, pairsHolder, nonPairsHolder) do
    biggestpair = hd ( hd pairsHolder)
    pairsHolder = replace(pairsHolder, 14, 1, true)
    nonPairsHolder = replace(nonPairsHolder, 14, 1, true)
    p1 = hd pairsHolder
    p2 = hd (tl pairsHolder)
    p3 = hd (tl (tl pairsHolder))
    p4 = hd (tl (tl (tl pairsHolder)))
    c5 = hd nonPairsHolder
    [[p1,p2,p3,p4,c5], 8, [biggestpair, (hd p3), (hd c5)]]
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
    [[c5,c4,c3,c2,c1], 10, [(hd c5),(hd c4),(hd c3),(hd c2),(hd c1)]]
  end
end
