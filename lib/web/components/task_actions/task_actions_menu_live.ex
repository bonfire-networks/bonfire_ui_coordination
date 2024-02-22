defmodule Bonfire.UI.Coordination.TaskActionsMenuLive do
  use Bonfire.UI.Common.Web, :stateless_component

  prop task, :map, required: true
  prop is_editable?, :boolean, default: false
end
