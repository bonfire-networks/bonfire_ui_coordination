defmodule Bonfire.UI.Coordination.HeroLive do
  use Bonfire.UI.Common.Web, :stateless_component

  prop nav_items, :list, default: []
  prop page, :string, default: nil
  prop selected_tab, :string, default: nil
end
