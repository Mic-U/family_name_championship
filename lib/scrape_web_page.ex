defmodule ScrapeWebPage do
  @moduledoc """
    http://myoujijiten.web.fc2.com/50ontuuran.htmlから苗字一覧を取得する
  """

  def getHTML(url) do
    IO.puts "Search to #{url}"
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        findFamilyNameList(body)
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts "Not found :("
        list = []
        list
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
        list = []
        list
    end
  end

  defp findFamilyNameList(body) do
    Floki.find(body, "div tbody tr")
      |> Enum.map(&(findName(&1)))
      |> Enum.filter(&(String.length(&1) > 0))
  end

  defp findName(tr) do
    elem(tr, 2)
      |> Enum.at(1)
      |> elem(2)
      |> Enum.at(0)
      |> addToList
  end

  defp addToList(text) do
    case is_binary(text) do
      true -> text
      _ -> ""
    end
  end
end