defmodule Bonfire.UI.Coordination.MyTasksLive do
  use Bonfire.Web, :surface_view

  use AbsintheClient, schema: Bonfire.API.GraphQL.Schema, action: [mode: :internal]

  alias Bonfire.UI.ValueFlows.{IntentCreateActivityLive, CreateMilestoneLive, ProposalFeedLive, FiltersLive}
  alias Bonfire.Web.LivePlugs
  alias Bonfire.Me.Users
  alias Bonfire.Me.Web.{CreateUserLive, LoggedDashboardLive}
  # alias Bonfire.UI.Coordination.ResourceWidget

  def mount(params, session, socket) do

    LivePlugs.live_plug params, session, socket, [
      LivePlugs.LoadCurrentAccount,
      LivePlugs.LoadCurrentUser,
      LivePlugs.StaticChanged,
      LivePlugs.Csrf, LivePlugs.Locale,
      &mounted/3,
    ]
  end

  defp mounted(_params, _session, socket) do

    intents = intents(%{filters: %{provider: "me"}}, socket)
    debug(intents)

    {:ok, socket
    |> assign(
      page_title: "My tasks",
      page: "my_tasks",
      selected_tab: "events",
      smart_input: false,
      intents: intents,
      # resource: resource,
    )}
  end

  @intent_fields Bonfire.UI.Coordination.ProcessLive.intent_fields()
  @graphql """
  {
    intents(filter:{provider: "me", status: "open"}, limit: 200)
      #{@intent_fields}
  }
  """
  def intents(params \\ %{}, socket), do: liveql(socket, :intents, params)


  defdelegate handle_params(params, attrs, socket), to: Bonfire.Common.LiveHandlers
  def handle_event(action, attrs, socket), do: Bonfire.Common.LiveHandlers.handle_event(action, attrs, socket, __MODULE__)
  def handle_info(info, socket), do: Bonfire.Common.LiveHandlers.handle_info(info, socket, __MODULE__)

end
