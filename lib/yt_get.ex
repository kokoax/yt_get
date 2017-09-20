defmodule YtGet do
  def get_movie_list(keyword, page) do
    url = "https://www.youtube.com/results?search_query=#{keyword}&p=#{page}"
    %HTTPoison.Response{status_code: 200, body: body} = HTTPoison.get!(url)
    body
    |> Floki.parse
    |> Floki.find(".yt-uix-tile-link")
    |> get_title_and_url
  end

  def get_title_and_url(data) do
    Enum.zip(
      [data |> Floki.attribute("title"),
       data |> Floki.attribute("href") |> Enum.map(&("https://www.youtube.com" <> &1))]
    )
  end

  def print_title(movie_list) do
    Enum.zip(1..Enum.count(movie_list), movie_list)
    |> Enum.map(fn({num, {title, _}}) ->
      IO.puts "#{num}: #{title}"
    end)
  end

  def to_integer(str) do
    str
    |> String.replace(~r/\R/, "")
    |> String.to_integer
  end

  def at_movie(movie_list, page_num) do
    movie_list
    |> Enum.at((page_num |> to_integer)-1)
    |> elem(1)
  end

  def get_url(movie_list) do
    movie_list
    |> at_movie(IO.gets "movie num > ")
  end

  def open_page(url) do
    IO.inspect url
    System.cmd("chromium", [url])
  end

  def loop(keyword, page) do
    movie_list = keyword
    |> get_movie_list(page)

    movie_list |> print_title

    case IO.gets "> " do
      "next\n" -> loop(keyword, page+1)
      "n\n" -> loop(keyword, page+1)
      "prev\n" -> loop(keyword, page-1)
      "p\n" -> loop(keyword, page-1)
      "quit\n" -> 0
      "q\n" -> 0
      "o\n" -> movie_list |> get_url |> open_page
      "open\n" -> movie_list |> get_url |> open_page
      _     -> loop(keyword, page)
    end
  end

  def main(opts) do
    {options, _, _} = opts
    |> OptionParser.parse(switches: [keyword: :string])

    IO.inspect options

    # get_movie_list(options.keyword)
    loop(options[:keyword], 1)
  end
end
