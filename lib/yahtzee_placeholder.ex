defmodule YahtzeePlaceholder do
  use GenServer

  ## API
  def start_link(name) do
    reg_placeholder = placeholder_name(name)
    GenServer.start_link(__MODULE__, [], name: reg_placeholder)
  end

  def division(pid, number) do
    GenServer.call(pid, {:division, number})
  end

  def placeholder_name(name) do
    name = name <> "_placeholder"
    String.to_atom(name)
  end


  ## Callbacks
  @impl true
  def init(placeholder_name) do
    {:ok, placeholder_name}
  end

  @impl true
  def handle_call({:division, number}, _from, state) do
    number = 12 / number
    {:reply, number, state}
  end
end