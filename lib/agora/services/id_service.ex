defmodule Agora.IdService do
  @moduledoc """
  A service to generate keys for records we insert into our tables,
  since Mnesia doesn't auto-generate them for us.

  Abstracting this service decouples ID generation from the rest of the logic.
  In a more serious application I would use a full UUID.
  """
  @alphabet "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"

  @doc """
  Generates an id
  """
  @spec generate_id() :: String.t()
  def generate_id do
    Nanoid.generate(8, @alphabet)
  end
end
