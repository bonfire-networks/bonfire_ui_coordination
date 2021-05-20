defmodule Bonfire.UI.Coordination.TaskActionsMenuLive do
  use Bonfire.Web, :stateless_component
  alias Surface.Components.LivePatch

  prop task, :map, required: true

end
