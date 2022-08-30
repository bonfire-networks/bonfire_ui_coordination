defmodule Bonfire.UI.Coordination.CreateTaskLive do
  use Bonfire.UI.Common.Web, :stateless_component

  prop output_of_id, :string, default: nil
  prop textarea_class, :css_class, required: false
  prop textarea_container_class, :css_class # unused but workaround surface "invalid value for property" issue

end
