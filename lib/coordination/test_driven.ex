defmodule Bonfire.UI.Coordination.TestDrivenCoordination do
  @moduledoc false
  use GenServer

  def init(opts), do: {:ok, opts}

  def handle_cast({:suite_started, _opts}, config) do
    IO.inspect(config, label: "Tests started, with config:")

    {:noreply, config}
  end

  def handle_cast({:module_finished, %{tests: tests} = tested_module}, config) do
    # IO.inspect(tested_module, label: "Test for module done")
    Enum.each(tests, &handle_test(&1, config))
    {:noreply, config}
  end

  def handle_cast(event, config) do
    # IO.inspect(event, label: "Test event")
    {:noreply, config}
  end

  def handle_test(%{state: nil} = test, _config), do: post_test(test, :ok, ["Test OK"])
  def handle_test(%{state: {:invalid, module}} = test, _config), do: post_test(test, "The test seems invalid (#{inspect module})", ["Test fails"])
  def handle_test(%{state: {:skipped, reason}} = test, _config), do: post_test(test, "The test was skipped (#{reason})", ["Test skipped"]) # FIXME, skipped/excluded tests are not included in :module_finished
  def handle_test(%{state: {:excluded, reason}} = test, _config), do: post_test(test, "The test was excluded (#{reason})", ["Test skipped"])
  def handle_test(%{state: {:failed, failures}} = test, config) do
    error = ExUnit.Formatter.format_test_failure(test, failures, 1, 90000, &formatter(&1, &2, config))
    |> String.split(["\n"])
    |> Enum.drop(2)
    |> Enum.join("\n")

    post_test(test, error, ["Test fails"])
  end

  def post_test(test, status_or_comment, tags) do
    IO.puts("#{test.name} : #{inspect tags}")


    case status_or_comment do
      :ok ->
        # TODO: mark task as finished
        nil
      other ->
        # TODO: add comment to task (and mark as in progress)
        IO.puts(other)
        nil
    end

  end

  defp formatter(:blame_diff, msg, %{colors: colors} = config) do
    "-" <> msg <> "-"
  end

  # defp formatter(:extra_info, _msg, _config), do: ""

  defp formatter(_, msg, _config), do: msg


end
