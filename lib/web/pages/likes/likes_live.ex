defmodule Bonfire.UI.Coordination.LikesLive do
  use Bonfire.UI.Common.Web, :stateful_component

  alias Bonfire.Me.Users
  alias Bonfire.UI.Me.CreateUserLive

  # declare_nav_link(l("Starred"),
  #   page: "favourited",
  #   href: "/coordination/favourited",
  #   icon: "bi:stars"
  # )

  def update(assigns, socket) do
    %{edges: feed, page_info: page_info} =
      Bonfire.Social.Likes.list_my(
        current_user: current_user_required!(assigns),
        object_types: [ValueFlows.Planning.Intent]
      )

    # |> debug()

    {:ok,
     socket
     |> assign_global(category_link_prefix: "/coordination/tasks?tag_ids[]=")
     |> assign(
       showing_within: :likes,
       loading: false,
       selected_tab: "favourited",
       page: "likes",
       hide_filters: true,
       page_title: l("Important tasks"),
       create_object_type: :task,
       smart_input_opts: %{prompt: l("Add a task")},
       feed_name: :likes,
       feed: feed,
       page_info: page_info
     )}
  end

  # def mount(params, _session, socket) do
  #   {:ok,
  #    socket
  #    |> assign(
  #      feed: nil,
  #      page_info: nil,
  #      showing_within: :likes,
  #      loading: false,
  #      page: "likes",
  #      page_title: l("Important tasks"),
  #      create_object_type: :task,
  #      smart_input_opts: %{prompt: l("Add a task")}
  #    )}
  # end

  # def handle_params(_params, _url, socket) do
  #   current_user = current_user_required!(socket)

  #   %{edges: feed, page_info: page_info} =
  #     Bonfire.Social.Likes.list_my(
  #       current_user: current_user,
  #       object_types: [ValueFlows.Planning.Intent, ValueFlows.Proposal]
  #     )

  #   # |> debug()

  #   {:noreply,
  #    socket
  #    |> assign(
  #      feed: feed,
  #      page_info: page_info
  #    )}
  # end
end
