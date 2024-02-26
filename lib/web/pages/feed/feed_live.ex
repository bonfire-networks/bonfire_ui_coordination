defmodule Bonfire.UI.Coordination.FeedLive do
  use Bonfire.UI.Common.Web, :surface_live_view

  alias Bonfire.Social.Feeds.LiveHandler
  use AbsintheClient, schema: Bonfire.API.GraphQL.Schema, action: [mode: :internal]

  declare_nav_link(l("Timeline"), href: "/coordination/timeline", page: "feed", icon: "gg:feed")

  # declare_settings_nav_link(:extension,
  #   href: "/coordination/settings",
  #   verb: :tag,
  #   scopes: [:user, :instance]
  # )

  on_mount {LivePlugs, [Bonfire.UI.Me.LivePlugs.LoadCurrentUser]}

  def mount(params, _session, socket) do
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
       #  smart_input_opts: %{prompt: l("Add a task")},
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

  def handle_params(%{"tab" => tab} = params, _url, socket)
      when tab in [nil, "my", "local", "fediverse", "likes"] do
    {:noreply,
     assign(
       socket,
       LiveHandler.feed_default_assigns({maybe_to_atom(tab), params}, socket)
     )}
  end

  def handle_params(%{"tab" => tab}, _url, socket) do
    {:noreply,
     assign(
       socket,
       selected_tab: tab
     )}
  end

  def handle_params(_params, _url, socket) do
    handle_params(%{"tab" => nil}, nil, socket)
  end

  def handle_params(_nil, _url, socket) do
    {:noreply, assign(socket, selected_tab: "feed")}
  end

  def handle_event("select_tab", attrs, socket) do
    handle_params(%{"tab" => e(attrs, "name", nil)}, nil, socket)
  end
end
