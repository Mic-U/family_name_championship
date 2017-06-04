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

    champion = Enum.sort(list, fn (x, y) -> x[:hash] > y[:hash] end)
               |> Enum.at(0)
    IO.inspect champion
  end

  @doc """
    url5件ごとに並列で取得する
  """
  defp getByUrlGroup(urlGroup) do

    Enum.map(urlGroup, fn url ->
      Task.async(fn ->
        ScrapeWebPage.getHTML(url)
      end)
    end)
    |> Enum.map(&Task.await(&1, 10000))
    |> Enum.reduce(fn(x, acc) -> x ++ acc end)

  end
end
