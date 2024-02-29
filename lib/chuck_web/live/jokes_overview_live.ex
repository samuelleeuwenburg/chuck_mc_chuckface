defmodule ChuckWeb.JokesOverviewLive do
  use ChuckWeb, :live_view

  def render(assigns) do
    ~H"""
    hello jokes!
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
