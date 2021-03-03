defmodule Poker do

  def deal(cards) do translate(cards) end
  defp deal([], hand1, hand2, pool) do
    finalCards = [hand1] ++ [hand2] ++ [pool]
    IO.inspect finalCards
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

  # def compare(handPool1, handPool2) do

  # end


  # def checkSuit(cards) do
  #   {num,suit} = String.split_at(List.first(cards), 1)
  #   Enum.filter(cards, fn card ->
  #     {Cnum,Csuit} = String.split_at(card, 1)
  #     Csuit == suit
  #   end)
  # end

end
