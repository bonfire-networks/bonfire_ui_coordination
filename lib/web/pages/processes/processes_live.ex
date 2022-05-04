defmodule Bonfire.UI.Coordination.ProcessesLive do
  use Bonfire.UI.Common.Web, :live_view
  # use Surface.LiveView
  use AbsintheClient, schema: Bonfire.API.GraphQL.Schema, action: [mode: :internal]

  alias Bonfire.UI.Social.{HashtagsLive, ParticipantsLive}
  alias Bonfire.UI.ValueFlows.{IntentCreateActivityLive, CreateMilestoneLive, ProposalFeedLive, FiltersLive}
  alias Bonfire.Me.Web.LivePlugs
  alias Bonfire.Me.Users
  alias Bonfire.Me.Web.CreateUserLive
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

  defp mounted(_params, _session, socket) do

    processes = processes(socket)
    # debug(processes)

    {:ok, socket
    |> assign(
      page_title: "All processes",
      page: "processes",
      smart_input: false,
      processes: processes
    )}
  end

  @graphql """
  {
    processes {
      __typename
      id
      name
      note
      has_end
      intended_outputs {
        finished
      }
    }
  }
  """
  def processes(params \\ %{}, socket), do: liveql(socket, :processes, params)

  defdelegate handle_params(params, attrs, socket), to: Bonfire.UI.Common.LiveHandlers
  def handle_event(action, attrs, socket), do: Bonfire.UI.Common.LiveHandlers.handle_event(action, attrs, socket, __MODULE__)
  def handle_info(info, socket), do: Bonfire.UI.Common.LiveHandlers.handle_info(info, socket, __MODULE__)

end
