defmodule Testing do
  # def aReturn(c,_) do
  #   aReturn([1,2,3])
  # end

  # def aReturn([h|t]) do
  #   aReturn(t)
  # end

  # def aReturn([]) do
  #   [1,2,3,4,5,6,7,8,9,10]
  # end

  # def bReturn() do
  #   c = aReturn("true","dd")
  #   IO.inspect c
  # end

  # def caseTest() do
  #   case 5 do
  #     x >= 5 -> "bigger than 5"
  #     _ -> "smaller than 5"
  #   end
  # end

  def aTestMatch() do
      bTestMatch([1,2,3,4,5])
  end
  def bTestMatch([1,_,5]) do
    
  end
end
