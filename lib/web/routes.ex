defmodule Bonfire.UI.Coordination.Routes do
  defmacro __using__(_) do

    quote do

      # pages anyone can view
      scope "/", Bonfire.UI.Coordination do
        pipe_through :browser
        live "/list/:id", ProcessLive
        live "/lists", ProcessesLive
        live "/task/:id", TaskLive
        live "/my-tasks", MyTasks
      end

    end
  end
end
