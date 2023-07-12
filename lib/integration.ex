defmodule Bonfire.UI.Coordination.Integration do
  def repo, do: Bonfire.Common.Config.repo()

  def mailer, do: Bonfire.Common.Config.get!(:mailer_module)

  def remote_tag_prefix, do: nil

  # def remote_tag_prefix, do: "https://bonjour.bonfire.cafe/pub/actors/" # TODO: put in config
  def remote_tag_id, do: "#{remote_tag_prefix()}Task"
end
