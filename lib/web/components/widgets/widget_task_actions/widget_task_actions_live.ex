defmodule Bonfire.UI.Coordination.WidgetTaskActionsLive do
  use Bonfire.UI.Common.Web, :stateless_component

  prop intent, :any, default: nil
  prop widget_title, :string, default: nil
end
