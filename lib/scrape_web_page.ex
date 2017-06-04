defmodule ScrapeWebPage do
  @moduledoc """
    http://myoujijiten.web.fc2.com/50ontuuran.htmlから苗字一覧を取得する
  """

  @doc """
    urlからHTMLを取得
    苗字のリストに変換して返す

    ## param
      - url: 取得先URL
  """
  def getHTML(url) do
    IO.puts "Search to #{url}"
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        IO.puts "Get from #{url}"
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

  @doc """
    HTMLから苗字のリストを作成
    ## param
      - body: HTTPoisonで取得したHTML
  """
  defp findFamilyNameList(body) do
    Floki.find(body, "table[width=1000] tbody tr")
      |> Enum.map(&(findName(&1)))
      |> Enum.filter(&(String.length(&1) > 0))
      |> Enum.map(fn name ->
        [name: name, hash: cryptoString(name)]
      end)
  end

  @doc """
    tr要素から目当てのテキストを力技で掘り出す

    ## param
      - tr: tr要素
  """
  defp findName(tr) do
    elem(tr, 2)
      |> Enum.at(1)
      |> elem(2)
      |> Enum.at(0)
      |> addToList
  end

  @doc """
    各苗字をリストに追加
    ただし、文字列でナイト判定されれば空文字列にする
    空文字列は後の工程でフィルタリングされる
    ## param
      - text: tr要素から抽出したテキスト(苗字)
  """
  defp addToList(text) do
    case is_binary(text) do
      true -> text
      _ -> ""
    end
  end

  @doc """
    文字列をSHA256でハッシュ化する
    ## param
      - string: 入力文字列
  """
  defp cryptoString(string) do
    :crypto.hash(:sha256, string)
      |> Base.encode16(case: :lower)
  end

end
