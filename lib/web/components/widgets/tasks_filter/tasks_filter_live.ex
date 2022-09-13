defmodule Bonfire.UI.Coordination.TasksFilterLive do
  use Bonfire.UI.Common.Web, :stateless_component

  prop filters, :any, default: %{}
end
