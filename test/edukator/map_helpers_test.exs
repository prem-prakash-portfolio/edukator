defmodule Edukator.MapHelpersTest do
  use Edukator.DataCase

  describe "underscore_keys/1" do
    test "underscore keys" do
      res = %{"Arrodeio" => "1", "PaiDoCeu" => 5} |> Edukator.MapHelpers.underscore_keys()
      assert Map.has_key?(res, "arrodeio") == true
      assert Map.has_key?(res, "pai_do_ceu") == true
    end
  end

  describe "atomize_keys/1" do
    test "atomize_keys" do
      res = %{"Arrodeio" => "1", "PaiDoCeu" => 5} |> Edukator.MapHelpers.atomize_keys()

      assert Map.has_key?(res, :Arrodeio) == true
      assert Map.has_key?(res, :PaiDoCeu) == true
    end
  end

  describe "stringify_keys/1" do
    test "map" do
      res = %{Arrodeio: "1", PaiDoCeu: 5} |> Edukator.MapHelpers.stringify_keys()

      assert Map.has_key?(res, "Arrodeio") == true
      assert Map.has_key?(res, "PaiDoCeu") == true
    end

    test "struct" do
      res =
        %Edukator.Accounts.User{name: "nome", email: "email"}
        |> Edukator.MapHelpers.stringify_keys()

      assert Map.has_key?(res, "name") == true
      assert Map.has_key?(res, "email") == true
    end
  end

  describe "deep_merge/1" do
    test "deep_merge" do
    end
  end
end
