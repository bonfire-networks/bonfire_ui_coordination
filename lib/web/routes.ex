defmodule Bonfire.UI.Coordination.Routes do
  def declare_routes, do: "coordination"

  defmacro __using__(_) do
    quote do
      # pages anyone can view
      scope "/coordination/", Bonfire.UI.Coordination do
        pipe_through(:browser)

        live("/favourites", LikesLive)
        live("/todo", MyTasksLive)
        live("/lists", ProcessesLive)

        # live("/lists", ProcessesLive, as: ValueFlows.Process)

        live("/list/:id", ProcessLive, as: ValueFlows.Process)

        live("/task/:id", TaskLive, as: ValueFlows.Planning.Intent)

        live("/tasks", TasksLive, as: ValueFlows.Planning.Intent)
        live("/tasks/:tab", TasksLive)

        live("/", FeedLive)
        live("/:tab", FeedLive)
      end
    end
  end
end
