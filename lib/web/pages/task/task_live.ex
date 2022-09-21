defmodule Bonfire.UI.Coordination.TaskLive do
  use Bonfire.UI.Common.Web, :surface_live_view
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

  defp mounted(%{"id" => id} = _params, _session, socket) do
    intent = intent(%{id: id}, socket)

    # debug(intent)

    if !intent || intent == %{intent: nil} do
      {:error, :not_found}
    else
      id = ulid(intent)

      {:ok,
       socket
       |> assign(
         page_title: e(intent, :name, nil) || l("Task"),
         page: "task",
         selected_tab: "events",
         #  create_object_type: :task, # TODO: ability to reply to a task with a task
         context_id: id,
         #  reply_to_id: id,
         smart_input_prompt: l("Reply to this task"),
         without_sidebar: true,
         sidebar_widgets: [
           users: [
             secondary: [
               {Bonfire.UI.Coordination.WidgetTaskActionsLive, [intent: intent]}
             ]
           ]
         ],
         intent: intent

         # resource: resource,
       )
       |> assign_global(
         my_processes: Bonfire.UI.ValueFlows.ProcessesListLive.my_processes(current_user(socket))
       )}
    end
  end

  defp mounted(_, %{"params" => params} = _session, socket) do
    mounted(params, nil, socket)
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

  # defdelegate handle_params(params, attrs, socket), to: Bonfire.UI.Common.LiveHandlers

  def handle_event(action, attrs, socket),
    do: Bonfire.UI.Common.LiveHandlers.handle_event(action, attrs, socket, __MODULE__)

  def handle_info(info, socket),
    do: Bonfire.UI.Common.LiveHandlers.handle_info(info, socket, __MODULE__)
end
