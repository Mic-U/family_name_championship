defmodule FamilyNameChampionship do
  @moduledoc """
   Decide the STRONGEST family name in Japan.
  """

  def main() do
    IO.puts "Start"
    urlGroups = UrlList.get()
            |> Enum.chunk(5, 5, [])

    list = Enum.map(urlGroups, &(getByUrlGroup(&1)))
           |> Enum.reduce(fn(x, acc) -> Enum.concat(x, acc) end)
    IO.puts "Get All Lists"

    IO.puts "#{length(list)} Names Entry"

    results = Enum.chunk(list, 20, 20, [])
              |> Enum.map(&(chunkLeague(&1, list)))
              |> Enum.reduce(fn(x, acc) -> x ++ acc end)
    champion = Enum.sort(results, fn (x, y) -> x[:win] > y[:win] end)
               |> Enum.at(0)

    IO.inspect champion
  end

  defp getByUrlGroup(urlGroup) do

    Enum.map(urlGroup, fn url ->
      Task.async(fn ->
        ScrapeWebPage.getHTML(url)
      end)
    end)
    |> Enum.map(&Task.await(&1, 10000))
    |> Enum.reduce(fn(x, acc) -> x ++ acc end)

  end

  defp chunkLeague(chunk, allNames) do
    Enum.map(chunk, fn name ->
      Task.async(fn  -> League.battleResult(name, allNames) end)
    end)
    |> Enum.map(&Task.await(&1, 10000))
  end
end
