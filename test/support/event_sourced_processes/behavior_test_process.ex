defmodule Eventize.BehaviorTestProcess do
  @moduledoc false

  use Eventize.EventSourcedProcess

  defmodule InitialBehavior do
    def execute_call(:enter_secondary, _from, _context) do
      {[{:seconday_behavior_entered, %{}}], :ok}
    end

    def execute_call(:enter_initial, _from, _context) do
      {:error, "Already in initial"}
    end

    def execute_call(:ping, _from, _context) do
      :pong
    end

    def execute_cast(:enter_secondary, _context) do
      [{:seconday_behavior_entered, %{}}]
    end

    def execute_cast(:enter_initial, _context) do
      []
    end
  end

  defmodule SecondaryBehavior do
    def execute_call(:enter_initial, _from, _context) do
      {[{:initial_behavior_entered, %{}}], :ok}
    end

    def execute_call(:enter_secondary, _from, _context) do
      {:error, "Already in secondary"}
    end

    def execute_call(:ping, _from, _context) do
      :pong
    end

    def execute_cast(:enter_initial, _context) do
      [{:initial_behavior_entered, %{}}]
    end

    def execute_cast(:enter_secondary, _context) do
      []
    end
  end

  def start_link(%{id: id} = data) do
    GenServer.start_link(
      __MODULE__,
      data,
      name: {:global, id}
    )
  end

  @impl true
  def start(_id) do
    {InitialBehavior, %{}}
  end

  defp apply_event({:seconday_behavior_entered, %{}}, state) do
    {state, SecondaryBehavior}
  end

  defp apply_event({:initial_behavior_entered, %{}}, state) do
    {state, InitialBehavior}
  end
end
