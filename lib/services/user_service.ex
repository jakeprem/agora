defmodule Agora.UserService do
  @moduledoc """
  Service for creating a user account.
  """

  alias Agora.IdService

  @tablename User

  def init do
    case :mnesia.create_table(@tablename,
           attributes: [:id, :first_name, :last_name],
           disc_copies: [node()]
         ) do
      {:atomic, :ok} ->
        :ok

      {:aborted, {:already_exists, @tablename}} ->
        {:ok, "user table already created"}

      {:aborted, reason} ->
        {:error, reason}
    end
  end

  def create(first_name, last_name) do
    new_user_record = {
      @tablename,
      IdService.generate_id(),
      first_name,
      last_name
    }

    :mnesia.transaction(fn ->
      :mnesia.write(new_user_record)
    end)
    |> case do
      {:atomic, :ok} -> {:ok, new_user_record}
      other -> {:error, other}
    end
  end

  def read(id) do
    :mnesia.transaction(fn ->
      :mnesia.read({@tablename, id})
    end)
    |> case do
      {:atomic, [user]} -> {:ok, user}
      {:aborted, reason} -> {:error, reason}
    end
  end

  def list_ids do
    :mnesia.transaction(fn ->
      :mnesia.all_keys(@tablename)
    end)
    |> case do
      {:atomic, keys} -> keys
      other -> other
    end
  end
end
