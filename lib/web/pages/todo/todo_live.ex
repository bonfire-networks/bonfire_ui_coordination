defmodule Bonfire.UI.Coordination.TodoLive do
  use Bonfire.UI.Common.Web, :surface_live_view

  use AbsintheClient, schema: Bonfire.API.GraphQL.Schema, action: [mode: :internal]

  alias Bonfire.UI.ValueFlows.IntentCreateActivityLive
  alias Bonfire.UI.ValueFlows.CreateMilestoneLive

  alias Bonfire.UI.ValueFlows.FiltersLive

  alias Bonfire.Me.Users
  alias Bonfire.UI.Me.CreateUserLive

  # alias Bonfire.UI.Coordination.ResourceWidget

  declare_nav_link(l("All tasks"),
    page: "todo",
    href: "/coordination/todo",
    icon: "carbon:task-asset-view"
  )

  on_mount {LivePlugs, [Bonfire.UI.Me.LivePlugs.LoadCurrentUser]}

  def mount(params, _session, socket) do
    intents = intents(%{"action" => "work"}, socket)

    {:ok,
     socket
     |> assign(
       page_title: l("All tasks"),
       page: "todo",
       selected_tab: "todo",
       intents: intents,
       #  create_object_type: :task,
       #  smart_input_prompt: l("Add a task"),
       sidebar_widgets: [
         users: [
           secondary: [
             {Bonfire.Tag.Web.WidgetTagsLive, []}
           ]
         ]
       ]
     )}
  end

  @intent_fields Bonfire.UI.Coordination.ProcessLive.intent_fields()
  # TODO: pagination with intentsPages
  # filter:{
  #   agent: "me",
  #   # provider: "me",
  #   # receiver: "me",
  #   status: "open"
  #   # startDate: nil,
  #   # endDate: nil,
  #   # action:"work",
  #   # finished: false,
  #   # tagIds: []
  # }
  @filters [
    "agent",
    "provider",
    "receiver",
    "status",
    "action",
    "start_date",
    "end_date",
    "finished",
    "tag_ids",
    "search_string"
  ]
  @graphql """
  query($filters: IntentSearchParams) {
    intents(filter: $filters, limit: 200)
      #{@intent_fields}
  }
  """
  def intents(params \\ %{}, socket), do: liveql(socket, :intents, params)

  defp merge_filters(params, extra) do
    Map.merge(filter_filters(params), extra)
    |> debug()
  end

  defp filter_filters(params) do
    params
    |> Map.filter(fn
      {_, ""} -> false
      {name, _} when name in @filters -> true
      _ -> false
    end)
  end

  defp do_filter(
         %{
           "field" => field,
           "id" => value
         } = attrs,
         socket
       ) do
    do_filter(Map.put(%{}, field, value), socket)
  end

  defp do_filter(attrs, socket) do
    debug(attrs)

    params =
      attrs
      |> Map.filter(fn
        {_, ""} -> false
        {name, _} when name in @filters -> true
        _ -> false
      end)
      # |> debug()
      |> URI.encode_query()

    {:noreply, patch_to(socket, current_url(socket) <> "?" <> params)}
  end

  def handle_event("filter", %{"_target" => ["search_string"]} = attrs, socket) do
    debug("ignore")
    {:noreply, socket}
  end

  def handle_event("filter", attrs, socket) do
    do_filter(attrs, socket)
  end

  def handle_event("search", attrs, socket) do
    do_filter(attrs, socket)
  end
end
