defmodule Edukator.TokenGenerator do
  @moduledoc """
  Module that generates a token (random string)
  """

  def digest(key, token) do
    :crypto.hmac(:sha256, key, token)
    |> Base.encode16(case: :lower)
  end

  def generate(key) do
    raw = friendly_token()

    enc =
      :crypto.hmac(:sha256, key, raw)
      |> Base.encode16(case: :lower)

    {raw, enc}
  end

  def friendly_token(length \\ 20) do
    rlength = div(length * 3, 4)

    rlength
    |> urlsafe_base64()
    |> String.replace("l", "s")
    |> String.replace("I", "x")
    |> String.replace("O", "y")
    |> String.replace("0", "z")
  end

  def urlsafe_base64(length) do
    length
    |> :crypto.strong_rand_bytes()
    |> :base64.encode_to_string()
    |> to_string
    |> String.replace(~r/[\n\=]/, "")
    |> String.replace(~r/\+/, "-")
    |> String.replace(~r/\//, "_")
  end
end
