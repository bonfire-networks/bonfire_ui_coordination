defmodule Bonfire.UI.Coordination.Integration do
  def repo, do: Bonfire.Common.Config.repo()

  def mailer, do: Bonfire.Common.Config.get!(:mailer_module)

  # TODO: put in config
  def remote_tag_id, do: "https://bonjour.bonfire.cafe/pub/actors/Task"
end
