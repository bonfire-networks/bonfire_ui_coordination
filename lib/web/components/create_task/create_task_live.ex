defmodule Bonfire.UI.Coordination.CreateTaskLive do
  use Bonfire.UI.Common.Web, :stateless_component

  prop context_id, :string, default: nil

  prop smart_input_opts, :map, default: %{}
  prop textarea_class, :css_class, required: false
  # unused but workaround surface "invalid value for property" issue
  prop textarea_container_class, :css_class

  prop to_boundaries, :any, default: nil
  prop open_boundaries, :boolean, default: false

  @behaviour Bonfire.UI.Common.SmartInputModule
  def smart_input_module, do: [:task]
end
