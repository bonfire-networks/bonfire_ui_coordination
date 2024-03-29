defmodule Bonfire.UI.Coordination.ProcessesLive do
  use Bonfire.UI.Common.Web, :surface_live_view
  # use Surface.LiveView
  use AbsintheClient, schema: Bonfire.API.GraphQL.Schema, action: [mode: :internal]

  alias Bonfire.UI.Social.HashtagsLive
  alias Bonfire.UI.Social.ParticipantsLive

  alias Bonfire.UI.ValueFlows.IntentCreateActivityLive
  alias Bonfire.UI.ValueFlows.CreateMilestoneLive

  alias Bonfire.UI.ValueFlows.FiltersLive

  alias Bonfire.Me.Users
  alias Bonfire.UI.Me.CreateUserLive

  # alias Bonfire.UI.Coordination.ResourceWidget

  declare_nav_link(l("Milestones"),
    page: "milestones",
    href: "/coordination/milestones",
    icon: "lucide:milestone"
  )

  on_mount {LivePlugs, [Bonfire.UI.Me.LivePlugs.LoadCurrentUser]}

  def mount(params, _session, socket) do
    processes = processes(socket)

    {:ok,
     socket
     |> assign_global(category_link_prefix: "/coordination/tasks?tag_ids[]=")
     |> assign(
       page_title: l("milestones"),
       page: "milestones",
       processes: processes,
       #  page_header_aside: [
       #    {Bonfire.UI.Common.SmartInputButtonLive,
       #     [
       #       component: Bonfire.UI.ValueFlows.CreateProcessLive,
       #       smart_input_prompt: l("Add a list"),
       #       icon: "heroicons-solid:pencil-alt"
       #     ]}
       #  ],
       create_object_type: :process,
       smart_input_opts: %{prompt: l("New milestone")},
       sidebar_widgets: [
         users: [
           secondary: [
             {Bonfire.Tag.Web.WidgetTagsLive, []}
           ]
         ]
       ]
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
        id
        finished
      }
    }
  }
  """
  def processes(params \\ %{}, socket), do: liveql(socket, :processes, params)
end
