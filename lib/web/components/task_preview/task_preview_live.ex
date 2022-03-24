defmodule Bonfire.UI.Coordination.TaskPreviewLive do
  use Bonfire.Web, :stateless_component
  alias Surface.Components.LivePatch


  prop object, :any, required: true

  # FIXME! update no longer works in stateless
  def update(assigns, socket) do
    # TODO: run these preloads when fetching the feed, rather than n+1
    {:ok, socket |>
      assigns_merge(assigns,
        object: assigns.object
        |> preloads() #|> IO.inspect
      )
    }
  end

  def intent_preloads(), do: [provider: [:profile, :character]]

  def preloads(object) do
    object
    |> repo().maybe_preload(intent_preloads())
  end
end
