defmodule Bonfire.UI.Coordination.FeedLive do
  use Bonfire.UI.Common.Web, :surface_live_view
  alias Bonfire.UI.Me.LivePlugs
  alias Bonfire.Social.Feeds.LiveHandler

  declare_extension("Coordination",
    icon: "noto:high-voltage",
    default_nav: [
      Bonfire.UI.Coordination.FeedLive,
      Bonfire.UI.Coordination.MyTasksLive,
      Bonfire.UI.Coordination.LikesLive,
      Bonfire.UI.Coordination.ProcessesLive
      # {Bonfire.UI.ValueFlows.ProcessesListLive, process_url: "/coordination/list"}
    ]
  )

  declare_nav_link(l("Overview"), page: "feed", icon: "heroicons-solid:newspaper")

  # declare_settings_nav_link(:extension,
  #   href: "/coordination/settings",
  #   verb: :tag,
  #   scopes: [:user, :instance]
  # )

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
    nav_items = Bonfire.Common.ExtensionModule.default_nav(:bonfire_ui_coordination)

    {:ok,
     socket
     |> assign(
       #  selected_tab: "Overview",
       page: "Overview",
       page_title: l("My coordination feed"),
       nav_items: nav_items,
       feed: nil,
       page_info: nil,
       loading: false,
       feed_title: l("My coordination feed"),
       feed_component_id: "feeds",
       feed_id: nil,
       feed_ids: nil,
       object_types: object_types,
       feed_filters: %{
         object_type: object_types
       },
       feedback_title: l("Your feed is empty"),
       feedback_message:
         l("You can start by following some people, or writing adding some tasks yourself."),
       create_object_type: :task,
       smart_input_prompt: l("Add a task"),
       sidebar_widgets: [
         users: [
           secondary: [
             {Bonfire.Tag.Web.WidgetTagsLive, []}
           ]
         ],
         guests: [
           secondary: nil
         ]
       ]
     )}
  end

  def do_handle_params(%{"tab" => tab} = params, _url, socket)
      when tab in [nil, "my", "local", "fediverse", "likes"] do
    {:noreply,
     assign_generic(
       socket,
       LiveHandler.feed_assigns_maybe_async({maybe_to_atom(tab), params}, socket)
     )}
  end

  def do_handle_params(%{"tab" => tab}, _url, socket) do
    {:noreply,
     assign(
       socket,
       selected_tab: tab
     )}
  end

  def do_handle_params(_params, _url, socket) do
    do_handle_params(%{"tab" => nil}, nil, socket)
  end

  # defdelegate handle_params(params, attrs, socket), to: Bonfire.UI.Common.LiveHandlers
  def handle_params(params, uri, socket) do
    # poor man's hook I guess
    with {_, socket} <-
           Bonfire.UI.Common.LiveHandlers.handle_params(params, uri, socket, __MODULE__) do
      undead_params(socket, fn ->
        do_handle_params(params, uri, socket)
      end)
    end
  end

  def do_handle_event("select_tab", attrs, socket) do
    do_handle_params(%{"tab" => e(attrs, "name", nil)}, nil, socket)
  end

  def do_handle_event(action, attrs, socket) do
    debug(attrs, action)
    # poor man's hook I guess
    Bonfire.UI.Common.LiveHandlers.handle_event(action, attrs, socket, __MODULE__)
  end

  def handle_event(action, attrs, socket) do
    undead_params(socket, fn ->
      do_handle_event(action, attrs, socket)
    end)
  end

  def handle_info(info, socket),
    do: Bonfire.UI.Common.LiveHandlers.handle_info(info, socket, __MODULE__)
end
