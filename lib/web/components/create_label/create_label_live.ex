defmodule Bonfire.UI.Coordination.CreateLabelLive do
  use Bonfire.UI.Common.Web, :stateless_component

  prop smart_input_opts, :any, default: nil
  prop textarea_class, :css_class, required: false
  # unused but workaround surface "invalid value for property" issue
  prop textarea_container_class, :css_class
  prop flex, :boolean, default: false
  prop to_boundaries, :any, default: nil
  prop open_boundaries, :boolean, default: false
end
