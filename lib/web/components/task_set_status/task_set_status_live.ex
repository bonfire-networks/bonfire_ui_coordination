defmodule Bonfire.UI.Coordination.TaskSetStatusLive do
  use Bonfire.Web, :stateless_component

  prop task_id, :string
  prop redirect_after, :string
end
