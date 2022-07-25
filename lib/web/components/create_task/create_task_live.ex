defmodule Bonfire.UI.Coordination.CreateTaskLive do
  use Bonfire.UI.Common.Web, :stateless_component

  prop intent_url, :string, required: false, default: ""
  prop action, :string, required: false
  prop output_of_id, :string, required: false
  prop textarea_class, :css_class, required: false

end
