defmodule PlugContrib.Gzip do
  @moduledoc """
  Use this plug to gzip your responses, just include it in your controller or pipeline
  like below:

  ## Example
  ```
  plug PlugContrib.Gzip
  ```
  """
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    if accepts_gzip?(conn) do
      register_before_send(conn, &gzip/1)
    else
      conn
    end
  end

  @gzip_encoding "gzip"
  defp accepts_gzip?(conn) do
    conn
    |> get_req_header("accept-encoding")
    |> Enum.join(",")
    |> String.downcase()
    |> String.contains?(@gzip_encoding)
  end

  defp gzip(conn) do
    conn
    |> put_resp_header("content-encoding", @gzip_encoding)
    |> Map.put(:resp_body, :zlib.gzip(conn.resp_body))
  end
end
