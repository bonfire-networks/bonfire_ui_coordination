defmodule Bonfire.UI.Coordination.SidebarNavigationLive do
  use Bonfire.UI.Common.Web, :stateless_component
  alias Surface.Components.LivePatch

  prop page, :string, required: true
  prop username, :string, required: true
end
