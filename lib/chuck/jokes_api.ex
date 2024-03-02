defmodule Chuck.JokesAPI.Joke do
  defstruct [:id, :value]
end

defmodule Chuck.JokesAPI do
  @moduledoc """
  Module built around the chucknorris.io API
  """

  alias Chuck.JokesAPI.Joke

  @api_url "https://api.chucknorris.io/jokes"

  @doc """
  Fetch a random joke from the api

      iex> Chuck.JokesAPI.get_random
      {:ok, %Chuck.JokesAPI.Joke{id: "123", value: "Chuck Mc Chuckface"}}
  """
  def get_random() do
    case HTTPoison.get("#{@api_url}/random") do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        Poison.decode(body, %{as: %Joke{}})

      {_, response} ->
        {:error, response}
    end
  end

  @doc """
  Fetch a specific joke from the api based on its `id`

      iex> Chuck.JokesAPI.get("123")
      {:ok, %Chuck.JokesAPI.Joke{id: "123", value: "Chuck Mc Chuckface"}}
  """
  def get(id) do
    case HTTPoison.get("#{@api_url}/#{id}") do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        Poison.decode(body, %{as: %Joke{}})

      {_, response} ->
        {:error, response}
    end
  end

  @doc """
  Search the API based on a query, returns a list with jokes

      iex> Chuck.JokesAPI.search("chuckface")
      {:ok, [%Chuck.JokesAPI.Joke{id: "123", value: "Chuck Mc Chuckface"}]}
  """
  def search(query) do
    case HTTPoison.get("#{@api_url}/search?query=#{query}") do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        jokes =
          Poison.decode!(body)
          |> Map.fetch!("result")
          |> Enum.map(fn j -> %Joke{id: j["id"], value: j["value"]} end)

        {:ok, jokes}

      {_, response} ->
        {:error, response}
    end
  end
end
