defmodule Bonfire.UI.Coordination.MyTasksLive do
  use Bonfire.UI.Common.Web, :surface_live_view

  use AbsintheClient, schema: Bonfire.API.GraphQL.Schema, action: [mode: :internal]

  alias Bonfire.UI.ValueFlows.{IntentCreateActivityLive, CreateMilestoneLive, ProposalFeedLive, FiltersLive}
  alias Bonfire.UI.Me.LivePlugs
  alias Bonfire.Me.Users
  alias Bonfire.UI.Me.CreateUserLive
  # alias Bonfire.UI.Coordination.ResourceWidget


  declare_extension("Coordination", icon: "fa-solid:tasks", default_nav: [
    Bonfire.UI.Coordination.MyTasksLive,
    Bonfire.UI.Coordination.ProcessesLive
  ])

  declare_nav_link(l("My tasks"), icon: "heroicons-solid:newspaper")


  def mount(params, session, socket) do

    live_plug params, session, socket, [
      LivePlugs.LoadCurrentAccount,
      LivePlugs.LoadCurrentUser,
      Bonfire.UI.Common.LivePlugs.StaticChanged,
      Bonfire.UI.Common.LivePlugs.Csrf,
      Bonfire.UI.Common.LivePlugs.Locale,
      &mounted/3,
    ]
  end

  defp mounted(_params, _session, socket) do

    intents = intents(%{filters: %{agent: "me"}}, socket)
    debug(intents)

    {:ok, socket
    |> assign(
      page_title: "My tasks",
      page: "my_tasks",
      selected_tab: "events",
      create_activity_type: :task,
      smart_input_prompt: l("Add a task"),
      intents: intents
      # resource: resource,
    )}
  end

  @intent_fields Bonfire.UI.Coordination.ProcessLive.intent_fields()
  @graphql """
  {
    intents(filter:{agent: "me", status: "open"}, limit: 200)
      #{@intent_fields}
  }
  """
  def intents(params \\ %{}, socket), do: liveql(socket, :intents, params)


  defdelegate handle_params(params, attrs, socket), to: Bonfire.UI.Common.LiveHandlers
  def handle_event(action, attrs, socket), do: Bonfire.UI.Common.LiveHandlers.handle_event(action, attrs, socket, __MODULE__)
  def handle_info(info, socket), do: Bonfire.UI.Common.LiveHandlers.handle_info(info, socket, __MODULE__)

end
