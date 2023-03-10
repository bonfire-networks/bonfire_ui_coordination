defmodule Bonfire.UI.Coordination.TaskHeroLive do
  use Bonfire.UI.Common.Web, :stateless_component

  prop task, :map
  prop showing_within, :atom, default: :task
  prop is_editable?, :boolean, default: false
end
