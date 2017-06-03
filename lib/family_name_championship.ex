defmodule FamilyNameChampionship do
  @moduledoc """
   Decide the STRONGEST family name in Japan.
  """

  def main([]) do
    IO.puts "Start"
    url = "http://myoujijiten.web.fc2.com/a1.html";
    list = ScrapeWebPage.getHTML(url)
    name = Enum.at(list, 0)
    player = "三木"
    IO.puts player > name
  end
end
