defmodule Bonfire.UI.Coordination.TaskSetStatusLive do
  use Bonfire.UI.Common.Web, :stateless_component

  prop task_id, :string
  prop redirect_after, :string
  prop finished, :boolean
end
