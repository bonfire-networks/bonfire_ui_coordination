defmodule Bonfire.UI.Coordination.TaskActionsMenuLive do
  use Bonfire.UI.Common.Web, :stateless_component
  alias Surface.Components.LivePatch

  prop task, :map, required: true
  prop is_editable?, :boolean, default: false
end
