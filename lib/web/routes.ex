defmodule Bonfire.UI.Coordination.Routes do
  defmacro __using__(_) do
    quote do
      # pages anyone can view
      scope "/coordination/", Bonfire.UI.Coordination do
        pipe_through(:browser)

        live("/", FeedLive)

        live("/favourites", LikesLive)

        live("/lists", ProcessesLive)

        live("/list/:id", ProcessLive, as: ValueFlows.Process)
        live("/list/", ProcessLive, as: ValueFlows.Process)

        live("/task/:id", TaskLive, as: ValueFlows.Planning.Intent)

        live("/tasks", TasksLive, as: ValueFlows.Planning.Intent)
        live("/tasks/:tab", TasksLive)
      end
    end
  end
end
