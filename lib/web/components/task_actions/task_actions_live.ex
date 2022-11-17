defmodule Bonfire.UI.Coordination.TaskActionsLive do
  use Bonfire.UI.Common.Web, :stateless_component

  prop intent, :any
  prop is_editable?, :boolean, default: false
end
