defmodule Bonfire.UI.Coordination.Routes do
  defmacro __using__(_) do

    quote do

      alias Bonfire.UI.Coordination.Routes.Helpers, as: SocialRoutes

      # pages anyone can view
      scope "/", Bonfire.UI.Coordination do
        pipe_through :browser
        live "/resource/:id", ResourceLive
        live "/process/:id", ProcessLive
        live "/process/:id/:tab", ProcessLive
      end

    end
  end
end
