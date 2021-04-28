defmodule Bonfire.UI.Coordination.Routes do
  defmacro __using__(_) do

    quote do

      alias Bonfire.UI.Coordination.Routes.Helpers, as: SocialRoutes

      # pages anyone can view
      scope "/", Bonfire.UI.Coordination do
        pipe_through :browser
        live "/list/:id", ProcessLive
        live "/list/:id/task/:task_id", TaskLive
      end

    end
  end
end
