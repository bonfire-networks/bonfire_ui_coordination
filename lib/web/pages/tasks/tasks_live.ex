defmodule Bonfire.UI.Coordination.TasksLive do
  use Bonfire.UI.Common.Web, :surface_live_view

  use AbsintheClient, schema: Bonfire.API.GraphQL.Schema, action: [mode: :internal]

  alias Bonfire.UI.ValueFlows.IntentCreateActivityLive
  alias Bonfire.UI.ValueFlows.CreateMilestoneLive

  alias Bonfire.UI.ValueFlows.FiltersLive

  alias Bonfire.UI.Me.LivePlugs
  alias Bonfire.Me.Users
  alias Bonfire.UI.Me.CreateUserLive

  # alias Bonfire.UI.Coordination.ResourceWidget

  declare_nav_link([
    {l("To do"),
     href: "/coordination/tasks?provider=me", icon: "heroicons:clipboard-document-check-solid"},
    {l("My tasks"), href: "/coordination/tasks/me", icon: "heroicons:hand-raised-20-solid"},
    {l("Discover tasks"), icon: "heroicons-solid:lightning-bolt"}
  ])

  def mount(params, session, socket) do
    live_plug(params, session, socket, [
      LivePlugs.LoadCurrentAccount,
      LivePlugs.LoadCurrentUser,
      Bonfire.UI.Common.LivePlugs.StaticChanged,
      Bonfire.UI.Common.LivePlugs.Csrf,
      Bonfire.UI.Common.LivePlugs.Locale,
      &mounted/3
    ])
  end

  defp mounted(_params, _session, socket) do
    {:ok,
     socket
     |> assign(
       page_title: l("Tasks"),
       page: "tasks",
       selected_tab: nil,
       create_object_type: :task,
       smart_input_prompt: l("Add a task"),
       sidebar_widgets: [
         users: [
           secondary: [
             {Bonfire.UI.Coordination.TasksFilterLive, []}
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

  def do_handle_params(%{"tab" => "me" = tab} = params, _url, socket) do
    intents =
      %{filters: merge_filters(params, %{"action" => "work", "agent" => "me"})}
      # |> debug()
      |> intents(socket)

    # |> debug()

    {:noreply,
     socket
     |> assign(
       page_title: l("Watched Tasks"),
       page: "tasks",
       selected_tab: tab,
       intents: intents,
       sidebar_widgets: [
         users: [
           secondary: [
             {Bonfire.UI.Coordination.TasksFilterLive, filters: params}
           ]
         ]
       ]
     )}
  end

  def do_handle_params(params, _url, socket) do
    intents =
      %{filters: merge_filters(params, %{"action" => "work"})}
      # |> debug()
      |> intents(socket)

    # |> debug()

    {:noreply,
     socket
     |> assign(
       page_title: l("Tasks"),
       page: "tasks",
       selected_tab: nil,
       intents: intents,
       sidebar_widgets: [
         users: [
           secondary: [
             {Bonfire.UI.Coordination.TasksFilterLive, filters: params}
           ]
         ]
       ]
     )}
  end

  defp filter_filters(params) do
    params
    |> Map.filter(fn
      {_, ""} -> false
      {name, _} when name in @filters -> true
      _ -> false
    end)
  end

  def handle_params(params, uri, socket) do
    # poor man's hook I guess
    with {_, socket} <-
           Bonfire.UI.Common.LiveHandlers.handle_params(params, uri, socket) do
      undead_params(socket, fn ->
        do_handle_params(params, uri, socket)
      end)
    end
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

  def handle_event(action, attrs, socket),
    do: Bonfire.UI.Common.LiveHandlers.handle_event(action, attrs, socket, __MODULE__)

  def handle_info(info, socket),
    do: Bonfire.UI.Common.LiveHandlers.handle_info(info, socket, __MODULE__)
end
