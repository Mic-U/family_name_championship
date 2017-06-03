defmodule League do

  def battleResult(player, nameList) do
   [
    name: player[:name],
    win: countWin(player, nameList)
   ]
  end

  defp countWin(player, nameList) do
    Enum.filter(nameList, fn (name) -> player[:hash] > name[:hash] end)
      |> length
  end
end
