defmodule Bonfire.UI.Coordination.FeedLive do
  use Bonfire.UI.Common.Web, :surface_live_view
  alias Bonfire.UI.Me.LivePlugs
  alias Bonfire.Social.Feeds.LiveHandler
  use AbsintheClient, schema: Bonfire.API.GraphQL.Schema, action: [mode: :internal]

  declare_nav_link(l("Timeline"), href: "/coordination/timeline", page: "feed", icon: "gg:feed")

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

    {:ok,
     socket
     |> assign(
       selected_tab: "feed",
       page: "feed",
       page_title: l("Timeline"),
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
       #  create_object_type: :task,
       #  smart_input_opts: [prompt: l("Add a task")],
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

  def do_handle_params(_nil, _url, socket) do
    {:noreply, assign(socket, selected_tab: "feed")}
  end

  def do_handle_event("select_tab", attrs, socket) do
    do_handle_params(%{"tab" => e(attrs, "name", nil)}, nil, socket)
  end

  def handle_params(params, uri, socket),
    do:
      Bonfire.UI.Common.LiveHandlers.handle_params(
        params,
        uri,
        socket,
        __MODULE__
      )

  def handle_info(info, socket),
    do: Bonfire.UI.Common.LiveHandlers.handle_info(info, socket, __MODULE__)

  def handle_event(
        action,
        attrs,
        socket
      ),
      do:
        Bonfire.UI.Common.LiveHandlers.handle_event(
          action,
          attrs,
          socket,
          __MODULE__,
          &do_handle_event/3
        )
end
