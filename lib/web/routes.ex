defmodule Bonfire.UI.Coordination.Routes do
  @behaviour Bonfire.UI.Common.RoutesModule

  defmacro __using__(_) do
    quote do
      # pages anyone can view
      scope "/coordination/", Bonfire.UI.Coordination do
        pipe_through(:browser)

        live("/favourites", LikesLive)
        live("/todo", TodoLive)
        live("/milestones", ProcessesLive)
        live("/labels", LabelsLive)
        live("/timeline", FeedLive)
        # live("/lists", ProcessesLive, as: ValueFlows.Process)

        live("/list/:id", ProcessLive, as: ValueFlows.Process)

        live("/task/:id", TaskLive, as: ValueFlows.Planning.Intent)

        live("/tasks", TasksLive, as: ValueFlows.Planning.Intent)
        live("/tasks/:tab", TasksLive)

        live("/", TasksLive)
        live("/:tab", TasksLive)
      end
    end
  end
end
