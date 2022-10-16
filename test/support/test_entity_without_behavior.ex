defmodule TestEntityWithoutBehavior do
  use Reactive.Entities.Entity

  defmodule Commands do
    defmodule Start do
      defstruct title: nil
    end
  end

  defmodule Events do
    defmodule Started do
      defstruct title: nil
    end
  end

  defmodule Responses do
    defmodule StartResponse do
      defstruct title: nil
    end
  end

  defmodule State do
    defstruct title: nil
  end
  
  def execute(%Reactive.Entities.Entity.ExecutionContext{}, %Commands.Start{:title => title}) do
    {[%Events.Started{title: title}], %Responses.StartResponse{title: title}}
  end
  
  defp on(_, %Events.Started{:title => title}) do
    %State{title: title}
  end
end