defmodule Bonfire.UI.Coordination.LabelsLive do
  use Bonfire.UI.Common.Web, :surface_live_view

  alias Bonfire.UI.Topics.CategoryLive.SubcategoriesLive
  alias Bonfire.Classify.Web.CommunityLive.CommunityCollectionsLive
  alias Bonfire.Classify.Web.CollectionLive.CollectionResourcesLive

  on_mount {LivePlugs, [Bonfire.UI.Me.LivePlugs.LoadCurrentUser]}

  def label_id, do: "1ABE1SC1ASS1FYC00RD1NAT10N"

  def mount(params, _session, socket) do
    current_user = current_user(socket.assigns)

    label_category = label_id()

    id =
      if not is_nil(params["id"]) and params["id"] != "" do
        params["id"]
      else
        if not is_nil(params["username"]) and params["username"] != "" do
          params["username"]
        else
          label_category
        end
      end

    {:ok, category} =
      with {:error, :not_found} <-
             Bonfire.Classify.Categories.get(id, [
               :default_incl_deleted,
               current_user: current_user(socket.assigns)
             ]) do
        Bonfire.Label.Labels.get_or_create(label_category, "Coordination Labels")
      end

    # TODO: query children with boundaries
    {:ok, subcategories} =
      Bonfire.Classify.GraphQL.CategoryResolver.category_children(
        %{id: ulid!(category)},
        %{limit: 15},
        %{context: %{current_user: current_user}}
      )
      |> debug("subcategories")

    name = e(category, :profile, :name, l("Untitled topic"))
    object_boundary = Bonfire.Boundaries.Controlleds.get_preset_on_object(category)

    {:ok,
     socket
     |> assign_global(category_link_prefix: "/coordination/tasks?tag_ids[]=")
     |> assign(
       page: "labels",
       object_type: nil,
       feed: nil,
       tab_id: nil,
       create_object_type: :label,
       smart_input_opts: %{prompt: l("New label")},
       category: category,
       canonical_url: canonical_url(category),
       name: name,
       page_title: name,
       interaction_type: l("follow"),
       subcategories: subcategories.edges,
       #  current_context: category,
       #  context_id: ulid(category),
       #  reply_to_id: category,
       object_boundary: object_boundary,
       #  create_object_type: :category,
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
       ]
     )}
  end

  def tab(selected_tab) do
    case maybe_to_atom(selected_tab) do
      tab when is_atom(tab) -> tab
      _ -> :timeline
    end

    # |> debug
  end

  def do_handle_params(%{"tab" => tab, "tab_id" => tab_id}, _url, socket) do
    # debug(id)
    {:noreply,
     assign(socket,
       selected_tab: tab,
       tab_id: tab_id
     )}
  end

  def do_handle_params(%{"tab" => tab}, _url, socket) do
    {:noreply,
     assign(socket,
       selected_tab: tab
     )}

    # nothing defined
  end

  def do_handle_params(params, _url, socket) do
    # default tab
    do_handle_params(
      Map.merge(params || %{}, %{"tab" => "timeline"}),
      nil,
      socket
    )
  end

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
