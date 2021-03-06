defmodule Bonfire.UI.Coordination.ProcessLive do
  use Bonfire.UI.Common.Web, :live_view
  # use Surface.LiveView
  use AbsintheClient, schema: Bonfire.API.GraphQL.Schema, action: [mode: :internal]

  alias Bonfire.UI.Social.{HashtagsLive, ParticipantsLive}
  alias Bonfire.UI.ValueFlows.{IntentCreateActivityLive, CreateMilestoneLive, ProposalFeedLive, FiltersLive}
  alias Bonfire.UI.Me.LivePlugs
  alias Bonfire.Me.Users
  alias Bonfire.UI.Me.CreateUserLive
  # alias Bonfire.UI.Coordination.ResourceWidget

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

  defp mounted(%{"id"=> id} = _params, _session, socket) do

    process = process(%{id: id}, socket)
    debug(process: process)

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
    __typename
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
    __typename
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
  def intent_fields, do: @intent_fields

  @graphql """
  query($id: ID, $intent_filter: IntentSearchParams) {
    process(id: $id) {
     __typename
     id
      name
      note
      has_end
      finished
      working_agents {
        __typename
        id
        name
        image
      }
      intended_inputs(filter: $intent_filter) #{@intent_fields}
      intended_outputs(filter: $intent_filter) #{@intent_fields}
    }
  }
  """

  def process(params \\ %{}, socket), do: liveql(socket, :process, params)
  def process_filtered(params \\ %{}, socket), do: liveql(socket, :process, params)

  # defdelegate handle_params(params, attrs, socket), to: Bonfire.UI.Common.LiveHandlers
  def do_handle_params(%{"filter" => status}, _, %{assigns: %{process: process}} = socket) do
    process = process_filtered(%{id: process.id, intent_filter: %{"status" => status}}, socket)
    {:noreply, socket |> assign(process: process)}
  end
  def do_handle_params(params, attrs, socket), do: {:noreply, socket}

  def handle_params(params, uri, socket) do
    # poor man's hook I guess
    with {_, socket} <- Bonfire.UI.Common.LiveHandlers.handle_params(params, uri, socket) do
      undead_params(socket, fn ->
        do_handle_params(params, uri, socket)
      end)
    end
  end

  def handle_event("search", %{"key" => "Enter", "value" => search_term} = attrs, %{assigns: %{process: process}} = socket) do
    process = process_filtered(%{id: process.id, intent_filter: %{"searchString" => search_term}}, socket)
    {:noreply, socket |> assign(process: process)}
  end

  def handle_event("search", attrs, socket) do
    {:noreply, socket}
  end

  def handle_event(action, attrs, socket), do: Bonfire.UI.Common.LiveHandlers.handle_event(action, attrs, socket, __MODULE__)
  def handle_info(info, socket), do: Bonfire.UI.Common.LiveHandlers.handle_info(info, socket, __MODULE__)
end
