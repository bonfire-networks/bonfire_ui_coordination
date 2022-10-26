defmodule Bonfire.UI.Coordination.LikesLive do
  use Bonfire.UI.Common.Web, :stateful_component

  alias Bonfire.UI.Me.LivePlugs
  alias Bonfire.Me.Users
  alias Bonfire.UI.Me.CreateUserLive

  declare_nav_link(l("Starred"), href: "/coordination/favourited", icon: "bi:stars")

  def update(assigns, socket) do
    %{edges: feed, page_info: page_info} =
      Bonfire.Social.Likes.list_my(
        current_user: current_user(assigns),
        object_type: [ValueFlows.Planning.Intent, ValueFlows.Proposal]
      )

    # |> debug()

    {:ok,
     socket
     |> assign(
       showing_within: :likes,
       loading: false,
       page: "likes",
       page_title: l("Important tasks"),
       create_object_type: :task,
       smart_input_prompt: l("Add a task"),
       feed: Bonfire.Social.Feeds.LiveHandler.preloads(feed, socket),
       page_info: page_info
     )}
  end

  # defp mounted(params, _session, socket) do
  #   {:ok,
  #    socket
  #    |> assign(
  #      feed: [],
  #      page_info: nil,
  #      showing_within: :likes,
  #      loading: false,
  #      page: "likes",
  #      page_title: l("Important tasks"),
  #      create_object_type: :task,
  #      smart_input_prompt: l("Add a task")
  #    )}
  # end

  # def do_handle_params(_params, _url, socket) do
  #   current_user = current_user_required(socket)

  #   %{edges: feed, page_info: page_info} =
  #     Bonfire.Social.Likes.list_my(
  #       current_user: current_user,
  #       object_type: [ValueFlows.Planning.Intent, ValueFlows.Proposal]
  #     )

  #   # |> debug()

  #   {:noreply,
  #    socket
  #    |> assign(
  #      feed: Bonfire.Social.Feeds.LiveHandler.preloads(feed, socket),
  #      page_info: page_info
  #    )}
  # end

  # def handle_params(params, uri, socket) do
  #   # poor man's hook I guess
  #   with {_, socket} <-
  #          Bonfire.UI.Common.LiveHandlers.handle_params(params, uri, socket) do
  #     undead_params(socket, fn ->
  #       do_handle_params(params, uri, socket)
  #     end)
  #   end
  # end

  def handle_event(action, attrs, socket),
    do: Bonfire.UI.Common.LiveHandlers.handle_event(action, attrs, socket, __MODULE__)

  defdelegate handle_params(params, attrs, socket), to: Bonfire.UI.Common.LiveHandlers

  def handle_info(info, socket),
    do: Bonfire.UI.Common.LiveHandlers.handle_info(info, socket, __MODULE__)
end
