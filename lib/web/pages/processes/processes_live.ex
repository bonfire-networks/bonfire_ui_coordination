defmodule Bonfire.UI.Coordination.ProcessesLive do
  use Bonfire.UI.Common.Web, :stateful_component
  # use Surface.LiveView
  use AbsintheClient, schema: Bonfire.API.GraphQL.Schema, action: [mode: :internal]

  alias Bonfire.UI.Social.HashtagsLive
  alias Bonfire.UI.Social.ParticipantsLive

  alias Bonfire.UI.ValueFlows.IntentCreateActivityLive
  alias Bonfire.UI.ValueFlows.CreateMilestoneLive

  alias Bonfire.UI.ValueFlows.FiltersLive

  alias Bonfire.UI.Me.LivePlugs
  alias Bonfire.Me.Users
  alias Bonfire.UI.Me.CreateUserLive

  # alias Bonfire.UI.Coordination.ResourceWidget

  declare_nav_link(l("Lists"),
    page: "lists",
    href: "/coordination/lists",
    icon: "heroicons-solid:archive"
  )

  # def mount(params, session, socket) do
  #   live_plug(params, session, socket, [
  #     LivePlugs.LoadCurrentAccount,
  #     LivePlugs.LoadCurrentUser,
  #     Bonfire.UI.Common.LivePlugs.StaticChanged,
  #     Bonfire.UI.Common.LivePlugs.Csrf,
  #     Bonfire.UI.Common.LivePlugs.Locale,
  #     &mounted/3
  #   ])
  # end

  def update(assigns, socket) do
    processes = processes(socket)

    {:ok,
     socket
     |> assign(
       page_title: "All lists",
       page: "processes",
       #  hide_smart_input: true,
       create_object_type: :process,
       smart_input_prompt: l("Create a list"),
       processes: processes
     )}
  end

  # defp mounted(_params, _session, socket) do
  #   processes = processes(socket)

  #   # debug(processes)

  #   {:ok,
  #    socket
  #    |> assign(
  #      page_title: "All lists",
  #      page: "processes",
  #      #  hide_smart_input: true,
  #      create_object_type: :process,
  #      smart_input_prompt: l("Create a list"),
  #      processes: processes
  #    )}
  # end

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

  def handle_event(action, attrs, socket),
    do: Bonfire.UI.Common.LiveHandlers.handle_event(action, attrs, socket, __MODULE__)

  def handle_info(info, socket),
    do: Bonfire.UI.Common.LiveHandlers.handle_info(info, socket, __MODULE__)
end
