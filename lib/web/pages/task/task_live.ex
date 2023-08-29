defmodule Bonfire.UI.Coordination.TaskLive do
  use Bonfire.UI.Common.Web, :surface_live_view
  use AbsintheClient, schema: Bonfire.API.GraphQL.Schema, action: [mode: :internal]

  alias Bonfire.UI.Social.HashtagsLive
  alias Bonfire.UI.Social.ParticipantsLive

  alias Bonfire.UI.ValueFlows.IntentCreateActivityLive
  alias Bonfire.UI.ValueFlows.CreateMilestoneLive

  alias Bonfire.UI.ValueFlows.FiltersLive

  alias Bonfire.Me.Users
  alias Bonfire.UI.Me.CreateUserLive

  # alias Bonfire.UI.Coordination.ResourceWidget

  on_mount {LivePlugs, [Bonfire.UI.Me.LivePlugs.LoadCurrentUser]}

  def mount(%{"id" => id} = params, _session, socket) do
    intent = intent(%{id: id}, socket)
    debug(intent, "theintent")

    if !intent || intent == %{intent: nil} do
      {:error, :not_found}
    else
      id = ulid(intent)
      current_user = current_user(socket.assigns)

      {:ok,
       socket
       |> assign_global(
         category_link_prefix: "/coordination/tasks?tag_ids[]=",
         my_processes: Bonfire.UI.ValueFlows.ProcessesListLive.my_processes(current_user)
       )
       |> assign(
         page_title: e(intent, :name, nil) || l("Task"),
         page: "task",
         selected_tab: "events",
         showing_within: e(params, "showing_within", nil) || :task,
         #  create_object_type: :task, # TODO: ability to reply to a task with a task
         context_id: id,
         #  reply_to_id: id,
         #  smart_input_opts: %{prompt: l("Reply to this task")},
         #  without_sidebar: true,
         sidebar_widgets: [
           users: [
             secondary: [
               {Bonfire.Tag.Web.WidgetTagsLive, []}
             ]
           ],
           guests: [
             secondary: [
               {Bonfire.Tag.Web.WidgetTagsLive, []}
             ]
           ]
         ],
         intent: intent,
         is_editable?:
           not is_nil(current_user) and Bonfire.Boundaries.can?(current_user, :edit, intent)

         # resource: resource,
       )}
    end
  end

  def mount(_, %{"params" => params} = _session, socket) do
    mount(params, nil, socket)
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
        tags
      }
    }
  """
  def intent(params \\ %{}, socket), do: liveql(socket, :intent, params)

  def handle_params(params, uri, socket),
    do:
      Bonfire.UI.Common.LiveHandlers.handle_params(
        params,
        uri,
        socket,
        __MODULE__
      )

  def handle_info(info, socket),
    do: Bonfire.UI.Common.LiveHandlers.handle_info(info, socket, __MODULE__)

  def handle_event(
        action,
        attrs,
        socket
      ),
      do:
        Bonfire.UI.Common.LiveHandlers.handle_event(
          action,
          attrs,
          socket,
          __MODULE__
          # &do_handle_event/3
        )
end
