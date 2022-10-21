defmodule Bonfire.UI.Coordination.FeedLive do
  use Bonfire.UI.Common.Web, :surface_live_view
  alias Bonfire.UI.Me.LivePlugs
  alias Bonfire.Social.Feeds.LiveHandler
  use AbsintheClient, schema: Bonfire.API.GraphQL.Schema, action: [mode: :internal]

  declare_extension("Coordination",
    icon: "noto:high-voltage",
    default_nav: [
      Bonfire.UI.Coordination.FeedLive,
      Bonfire.UI.Coordination.TasksLive,
      Bonfire.UI.Coordination.LikesLive,
      Bonfire.UI.Coordination.ProcessesLive,
      {Bonfire.UI.ValueFlows.ProcessesListLive, process_url: "/coordination/list"}
    ]
  )

  declare_nav_link(l("Overview"), icon: "heroicons-solid:newspaper")

  def mount(params, session, socket) do
    live_plug(params, session, socket, [
      LivePlugs.LoadCurrentAccount,
      LivePlugs.LoadCurrentUser,
      # LivePlugs.UserRequired,
      # LivePlugs.LoadCurrentAccountUsers,
      Bonfire.UI.Common.LivePlugs.StaticChanged,
      Bonfire.UI.Common.LivePlugs.Csrf,
      Bonfire.UI.Common.LivePlugs.Locale,
      &mounted/3
    ])
  end

  defp mounted(params, _session, socket) do
    object_types = [ValueFlows.Process, ValueFlows.Planning.Intent, ValueFlows.Proposal]
    processes = processes(socket)

    {:ok,
     socket
     |> assign(
       selected_tab: "feed",
       page: "feed",
       page_title: l("My coordination feed"),
       feed_id: nil,
       object_types: object_types,
       feed_filters: [
         object_type: object_types
       ],
       feed_ids: nil,
       feedback_title: l("Your feed is empty"),
       feedback_message:
         l("You can start by following some people, or writing adding some tasks yourself."),
       create_object_type: :task,
       smart_input_prompt: l("Add a task"),
       processes: processes,
       sidebar_widgets: [
         users: [
           secondary: [
              {Bonfire.UI.Coordination.UpcomingTaskLive, []},
             {Bonfire.Tag.Web.WidgetTagsLive, []}
           ]
         ],
         guests: [
           secondary: [
             {Bonfire.Tag.Web.WidgetTagsLive, []}
           ]
         ]
       ]
     )}
  end


  @graphql """
  {
    processes {
      __typename
      id
      name
      note
      has_end
      intended_outputs {
        finished
      }
    }
  }
  """
  def processes(params \\ %{}, socket), do: liveql(socket, :processes, params)

  def do_handle_params(%{"tab" => tab}, _url, socket) do
    {:noreply,
     assign(
       socket,
       selected_tab: tab
     )}
  end

  def do_handle_params(_params, _url, socket) do
    # debug("param")

    {:noreply, assign(socket, LiveHandler.feed_assigns_maybe_async(:default, socket))}
  end

  # defdelegate handle_params(params, attrs, socket), to: Bonfire.UI.Common.LiveHandlers
  def handle_params(params, uri, socket) do
    # poor man's hook I guess
    with {_, socket} <- Bonfire.UI.Common.LiveHandlers.handle_params(params, uri, socket) do
      undead_params(socket, fn ->
        do_handle_params(params, uri, socket)
      end)
    end
  end

  def handle_event(action, attrs, socket),
    do: Bonfire.UI.Common.LiveHandlers.handle_event(action, attrs, socket, __MODULE__)

  def handle_info(info, socket),
    do: Bonfire.UI.Common.LiveHandlers.handle_info(info, socket, __MODULE__)
end
