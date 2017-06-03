defmodule FamilyNameChampionship do
  @moduledoc """
   Decide the STRONGEST family name in Japan.
  """

  def main(player) do
    IO.puts "Player Name: #{player}"
    url = "http://myoujijiten.web.fc2.com/a1.html";
    list = ScrapeWebPage.getHTML(url)
    name = Enum.at(list, 0)
    IO.puts "#{player} vs #{name}: #{player > name}"
  end
end
