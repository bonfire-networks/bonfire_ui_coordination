defmodule Bonfire.UI.Coordination.TaskLive do
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

    intent = intent(%{id: id}, socket)
    IO.inspect(intent)

    {:ok, socket
    |> assign(
      page_title: "task",
      page: "task",
      selected_tab: "events",
      smart_input: false,
      intent: intent,
      # resource: resource,
    )}
  end


  @graphql """
    query($id: ID) {
      intent(id: $id) {
        id
        name
        note
        due
        finished
        context: in_scope_of
        provider {
          id
          name
          display_username
          image
        }

        output_of {
          id
          name
        }
        input_of {
          id
          name
        }
      }
    }
  """
  def intent(params \\ %{}, socket), do: liveql(socket, :intent, params)


  defdelegate handle_params(params, attrs, socket), to: Bonfire.Web.LiveHandler
  def handle_event(action, attrs, socket), do: Bonfire.Web.LiveHandler.handle_event(action, attrs, socket, __MODULE__)
  def handle_info(info, socket), do: Bonfire.Web.LiveHandler.handle_info(info, socket, __MODULE__)

end
