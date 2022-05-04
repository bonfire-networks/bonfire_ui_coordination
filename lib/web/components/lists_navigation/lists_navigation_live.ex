defmodule Bonfire.UI.Coordination.ListsNavigationLive do
  use Bonfire.UI.Common.Web, :stateless_component

  prop process_url, :string, default: "/list/"

end
