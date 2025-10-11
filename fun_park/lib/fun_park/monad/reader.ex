defmodule FunPark.Monad.Reader do
  @enforce_keys [:run]
  defstruct [:run]

  def pure(value), do: %__MODULE__{run: fn _env -> value end}

  def run(%__MODULE__{run: f}, env), do: f.(env)

  def asks(func), do: %__MODULE__{run: func}
end

defimpl FunPark.Monad, for: FunPark.Monad.Reader do
  alias FunPark.Monad.Reader

  def map(%Reader{run: f}, func), do: %Reader{run: fn env -> func.(f.(env)) end}

  def bind(%Reader{run: f}, func), do: %Reader{run: fn env -> func.(f.(env)).run.(env) end}

  def ap(%Reader{run: f_func}, %Reader{run: f_value}) do
    %Reader{run: fn env -> f_func.(env).(f_value.(env)) end}
  end
end
