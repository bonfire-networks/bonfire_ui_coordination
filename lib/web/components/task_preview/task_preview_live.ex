defmodule Bonfire.UI.Coordination.TaskPreviewLive do
  use Bonfire.UI.Common.Web, :stateless_component

  prop object, :any, required: true
  prop is_editable?, :boolean, default: false

  # FIXME! update no longer works in stateless
  def update(assigns, socket) do
    # TODO: run these preloads when fetching the feed, rather than n+1
    {:ok,
     socket
     |> assigns_merge(assigns,
       object:
         assigns.object
         # |> IO.inspect
         |> preloads()
     )}
  end

  def intent_preloads(), do: [provider: [:profile, :character]]

  def preloads(object) do
    object
    |> repo().maybe_preload(intent_preloads())
  end
end
