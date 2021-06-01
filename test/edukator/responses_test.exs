defmodule Edukator.ResponsesTest do
  # use Edukator.DataCase
  #
  # alias Edukator.Responses
  #
  # describe "responses" do
  #   alias Edukator.Responses.Response
  #
  #   @valid_attrs %{}
  #   @update_attrs %{}
  #   @invalid_attrs %{}
  #
  #   def response_fixture(attrs \\ %{}) do
  #     {:ok, response} =
  #       attrs
  #       |> Enum.into(@valid_attrs)
  #       |> Responses.create_response()
  #
  #     response
  #   end
  #
  #   test "list_responses/0 returns all responses" do
  #     response = response_fixture()
  #     assert Responses.list_responses() == [response]
  #   end
  #
  #   test "get_response!/1 returns the response with given id" do
  #     response = response_fixture()
  #     assert Responses.get_response!(response.id) == response
  #   end
  #
  #   test "create_response/1 with valid data creates a response" do
  #     assert {:ok, %Response{} = response} = Responses.create_response(@valid_attrs)
  #   end
  #
  #   test "create_response/1 with invalid data returns error changeset" do
  #     assert {:error, %Ecto.Changeset{}} = Responses.create_response(@invalid_attrs)
  #   end
  #
  #   test "update_response/2 with valid data updates the response" do
  #     response = response_fixture()
  #     assert {:ok, %Response{} = response} = Responses.update_response(response, @update_attrs)
  #   end
  #
  #   test "update_response/2 with invalid data returns error changeset" do
  #     response = response_fixture()
  #     assert {:error, %Ecto.Changeset{}} = Responses.update_response(response, @invalid_attrs)
  #     assert response == Responses.get_response!(response.id)
  #   end
  #
  #   test "delete_response/1 deletes the response" do
  #     response = response_fixture()
  #     assert {:ok, %Response{}} = Responses.delete_response(response)
  #     assert_raise Ecto.NoResultsError, fn -> Responses.get_response!(response.id) end
  #   end
  #
  #   test "change_response/1 returns a response changeset" do
  #     response = response_fixture()
  #     assert %Ecto.Changeset{} = Responses.change_response(response)
  #   end
  # end
end
