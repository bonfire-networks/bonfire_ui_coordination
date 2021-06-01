defmodule Bonfire.UI.Coordination.Routes do
  defmacro __using__(_) do

    quote do

      # pages anyone can view
      scope "/", Bonfire.UI.Coordination do
        pipe_through :browser
        live "/list/:id", ProcessLive, as: ValueFlows.Process
        live "/lists", ProcessesLive
        live "/task/:id", TaskLive, as: ValueFlows.Planning.Intent
        live "/my-tasks", MyTasksLive
      end

    end
  end
end
