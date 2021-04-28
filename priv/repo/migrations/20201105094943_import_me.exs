defmodule Bonfire.UI.Coordination.Repo.Migrations.ImportMe do
  use Ecto.Migration

  import Bonfire.UI.Coordination.Migration
  # accounts & users

  def change, do: migrate_me

end
