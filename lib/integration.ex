defmodule Bonfire.UI.Coordination do
  @moduledoc "./README.md" |> File.stream!() |> Enum.drop(1) |> Enum.join()
  use Bonfire.Common.Config

  def repo, do: Bonfire.Common.Config.repo()

  def mailer, do: Bonfire.Common.Config.get!(:mailer_module)

  def remote_tag_prefix, do: nil

  # def remote_tag_prefix, do: "https://bonjour.bonfire.cafe/pub/actors/" 
  def remote_tag_id, do: "#{remote_tag_prefix()}Task"
end
