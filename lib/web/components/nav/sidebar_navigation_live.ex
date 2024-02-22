defmodule Bonfire.UI.Coordination.SidebarNavigationLive do
  use Bonfire.UI.Common.Web, :stateless_component

  prop page, :string, required: true
  prop username, :string, required: true
end
