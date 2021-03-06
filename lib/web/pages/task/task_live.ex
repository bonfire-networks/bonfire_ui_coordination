defmodule Bonfire.UI.Coordination.TaskLive do
  use Bonfire.UI.Common.Web, :live_view
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

    intent = intent(%{id: id}, socket)
    # debug(intent)

    if !intent || intent == %{intent: nil} do
      {:error, :not_found}
    else
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
  end


  @graphql """
    query($id: ID) {
      intent(id: $id) {
        __typename
        id
        name
        note
        due
        finished
        context: in_scope_of
        provider {
          __typename
          id
          name
          display_username
          image
        }

        output_of {
          __typename
          id
          name
        }
        input_of {
          __typename
          id
          name
        }
      }
    }
  """
  def intent(params \\ %{}, socket), do: liveql(socket, :intent, params)


  defdelegate handle_params(params, attrs, socket), to: Bonfire.UI.Common.LiveHandlers
  def handle_event(action, attrs, socket), do: Bonfire.UI.Common.LiveHandlers.handle_event(action, attrs, socket, __MODULE__)
  def handle_info(info, socket), do: Bonfire.UI.Common.LiveHandlers.handle_info(info, socket, __MODULE__)

end
