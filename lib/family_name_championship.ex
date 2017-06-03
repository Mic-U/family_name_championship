defmodule FamilyNameChampionship do
  @moduledoc """
   Decide the STRONGEST family name in Japan.
  """
  def urlList do
    [
      "https://myoji-yurai.net/prefectureRanking.htm?prefecture=全国"
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
              |> Enum.map(&Task.await(&1, 10000))
    champion = Enum.sort(results, fn (x, y) -> x[:win] > y[:win] end)
               |> Enum.at(0)

    IO.inspect champion
  end
end
