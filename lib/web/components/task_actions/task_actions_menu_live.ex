defmodule Bonfire.UI.Coordination.TaskActionsMenuLive do
  use Bonfire.UI.Common.Web, :stateless_component
  alias Surface.Components.LivePatch

  prop task, :map, required: true

end
