defmodule Chuck.JokesAPI.Joke do
  defstruct [:id, :url, :value]
end

defmodule Chuck.JokesAPI do
  alias Chuck.JokesAPI.Joke

  @api_url "https://api.chucknorris.io/jokes"

  def get_random() do
    case HTTPoison.get("#{@api_url}/random") do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        Poison.decode(body, %{as: %Joke{}})

      {_, response} ->
        {:error, response}
    end
  end

  def get(id) do
    case HTTPoison.get("#{@api_url}/#{id}") do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        Poison.decode(body, %{as: %Joke{}})

      {_, response} ->
        {:error, response}
    end
  end

  def search(query) do
    case HTTPoison.get("#{@api_url}/search?query=#{query}") do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        jokes =
          Poison.decode!(body)
          |> Map.fetch!("result")
          |> Enum.map(fn j -> %Joke{id: j["id"], url: j["url"], value: j["value"]} end)

        {:ok, jokes}

      {_, response} ->
        {:error, response}
    end
  end
end
