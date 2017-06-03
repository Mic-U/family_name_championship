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
      "http://myoujijiten.web.fc2.com/ki2.html"

    ]
  end

  def main() do
    IO.puts "start"
    urls = urlList()

    tasks = Enum.map(urls, fn url ->
      Task.async(fn  ->
        ScrapeWebPage.getHTML(url)
      end)
    end)

    list = Enum.map(tasks, &Task.await(&1, 10000))
             |> Enum.reduce(fn(x, acc) -> x ++ acc end)

    IO.puts "Get All Lists"

    results = Enum.map(list, fn (name) ->
      Task.async(fn  ->
        League.battleResult(name, list)
      end)
    end)

    Enum.map(results, &Task.await(&1, 10000))
      |> Enum.map(fn (result) -> IO.puts "#{result[:name]} win: #{result[:win]}, lose: #{result[:lose]}" end)

#    Enum.map(list, &(League.battleResult(&1, list)))
#      |> Enum.map(fn (result) -> IO.puts "#{result[:name]} win: #{result[:win]}, lose: #{result[:lose]}" end)


  end
end
