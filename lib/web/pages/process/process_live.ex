efmodule Bonfire.UI.Coordination.ProcessLive do
  use Bonfire.Web, :live_view
  # use Surface.LiveView
  use AbsintheClient, schema: Bonfire.GraphQL.Schema, action: [mode: :internal]

  alias Bonfire.UI.Social.{HashtagsLive, ParticipantsLive}
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
      LivePlugs.Csrf,
      &mounted/3,
    ]
  end

  defp mounted(%{"id"=> id} = _params, _session, socket) do

    process = process(%{id: id}, socket)
    # IO.inspect(process)
    {:ok, socket
    |> assign(
      page_title: "process",
      page: "process",
      selected_tab: "tasks",
      smart_input: false,
      process: process,
    )}
  end

  @quantity_fields """
  {
    has_numerical_value
    has_unit {
      label
      symbol
    }
  }
  """

  @resource_fields """
  {
    id
    name
    note
    image
    onhand_quantity #{@quantity_fields}
    accounting_quantity #{@quantity_fields}
  }
  """

  @intent_fields """
  {
    id
    name
    note
    due
    finished
    context: in_scope_of
    available_quantity #{@quantity_fields}
    resource_quantity #{@quantity_fields}
    effort_quantity #{@quantity_fields}
    provider {
      id
      name
      display_username
      image
    }
    receiver {
      id
      name
      display_username
      image
    }
    resource_inventoried_as #{@resource_fields}
  }
  """

  @graphql """
    query($id: ID) {
      process(id: $id) {
        id
        name
        note
        has_end
        finished
        has_end
        working_agents {
          id
          name
          image
        }
        intended_inputs #{@intent_fields}
        intended_outputs #{@intent_fields}
      }
    }
  """
  def process(params \\ %{}, socket), do: liveql(socket, :process, params)

  @graphql """
    query($id: ID, $filters: agentIntentSearchParams) {
      process(id: $id) {
        id
        name
        note
        has_end
        finished
        working_agents {
          id
          name
          image
        }
        intended_inputs(filters: $filters) #{@intent_fields}
        intended_outputs(filters: $filters) #{@intent_fields}
      }
    }
  """

  def process_filtered(params \\ %{}, socket), do: liveql(socket, :process, params)


  defdelegate handle_params(params, attrs, socket), to: Bonfire.Web.LiveHandler
  def handle_event(action, attrs, socket), do: Bonfire.Web.LiveHandler.handle_event(action, attrs, socket, __MODULE__)
  def handle_info(info, socket), do: Bonfire.Web.LiveHandler.handle_info(info, socket, __MODULE__)

end
