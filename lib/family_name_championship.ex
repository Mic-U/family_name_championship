defmodule FamilyNameChampionship do
  @moduledoc """
   Decide the STRONGEST family name in Japan.
  """
  def urlList do
    [
      "http://myoujijiten.web.fc2.com/a1.html",
      "http://myoujijiten.web.fc2.com/a2.html",
      "http://myoujijiten.web.fc2.com/i1.html",
      "http://myoujijiten.web.fc2.com/i2.html",
      "http://myoujijiten.web.fc2.com/i3.html",
      "http://myoujijiten.web.fc2.com/u1.html",
      "http://myoujijiten.web.fc2.com/u2.html",
      "http://myoujijiten.web.fc2.com/e.html",
      "http://myoujijiten.web.fc2.com/o1.html",
      "http://myoujijiten.web.fc2.com/o2.html",
      "http://myoujijiten.web.fc2.com/ka1.html",
      "http://myoujijiten.web.fc2.com/ka2.html",
      "http://myoujijiten.web.fc2.com/ka3.html",
      "http://myoujijiten.web.fc2.com/ka4.html",
      "http://myoujijiten.web.fc2.com/ki1.html",
      "http://myoujijiten.web.fc2.com/ki2.html",
      "http://myoujijiten.web.fc2.com/ku1.html",
      "http://myoujijiten.web.fc2.com/ku2.html",
      "http://myoujijiten.web.fc2.com/ke.html",
      "http://myoujijiten.web.fc2.com/ko1.html",
      "http://myoujijiten.web.fc2.com/ko2.html",
      "http://myoujijiten.web.fc2.com/sa1.html",
      "http://myoujijiten.web.fc2.com/sa2.html",
      "http://myoujijiten.web.fc2.com/si1.html",
      "http://myoujijiten.web.fc2.com/si2.html",
      "http://myoujijiten.web.fc2.com/si3.html",
      "http://myoujijiten.web.fc2.com/su.html",
      "http://myoujijiten.web.fc2.com/se.html",
      "http://myoujijiten.web.fc2.com/so.html",
      "http://myoujijiten.web.fc2.com/ta1.html",
      "http://myoujijiten.web.fc2.com/ta2.html",
      "http://myoujijiten.web.fc2.com/ta3.html",
      "http://myoujijiten.web.fc2.com/ti.html"
    ]
  end

  def main() do
    IO.puts "start"
    urls = urlList()

    list = Enum.map(urls, &(ScrapeWebPage.getHTML(&1)))
             |> Enum.reduce(fn(x, acc) -> x ++ acc end)

    IO.puts "Get All Lists"

    results = Enum.map(list, fn (name) ->
                Task.async(fn  ->
                  League.battleResult(name, list)
                end)
              end)
              |> Enum.map(&Task.await(&1, 10000))
    champion = Enum.sort(results, fn (x, y) -> x[:win] > y[:win] end)
               |> Enum.at(0)

    IO.inspect champion
  end
end
