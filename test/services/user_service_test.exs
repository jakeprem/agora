defmodule Agora.UserServiceTest do
  use ExUnit.Case

  alias Agora.UserService

  setup_all do
    UserService.init()
    :mnesia.clear_table(User)

    :ok
  end

  describe "User can create an account" do
    test "account can be created and read" do
      # The easiest way to prove the account was written is to read it out again
      assert {:ok, user} = UserService.create("George", "Washington")

      {User, id, _, _} = user

      assert {:ok, ^user} = UserService.read(id)
    end
  end

  # test "User can log in to account"
end
