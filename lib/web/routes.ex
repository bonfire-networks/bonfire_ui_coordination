defmodule Bonfire.UI.Coordination.Routes do
  defmacro __using__(_) do
    quote do
      # pages anyone can view
      scope "/coordination/", Bonfire.UI.Coordination do
        pipe_through(:browser)
        live("/list/:id", ProcessLive, as: ValueFlows.Process)
        live("/", ProcessesLive, as: ValueFlows.Process)
        live("/task/:id", TaskLive, as: ValueFlows.Planning.Intent)
        live("/me", MyTasksLive)
      end
    end
  end
end
