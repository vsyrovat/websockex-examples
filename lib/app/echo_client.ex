defmodule App.EchoClient do
  use WebSockex
  require Logger

  @url "wss://echo.websocket.org"

  ## Interface

  def send_text(msg) do
    WebSockex.cast(__MODULE__, {:send, {:text, msg}})
  end

  def send_binary(payload) do
    WebSockex.cast(__MODULE__, {:send, {:binary, payload}})
  end

  ## Start

  def start_link(_opts \\ []) do
    WebSockex.start_link(@url, __MODULE__, %{}, name: __MODULE__)
  end

  ## Callbacks

  def handle_connect(_conn, state) do
    Logger.debug("[Echo] Connected")
    {:ok, state}
  end

  def handle_frame({:text, "close"}, state) do
    Logger.debug("[Echo] Received close command")
    {:close, state}
  end

  def handle_frame({type, msg}, state) do
    Logger.debug("[Echo] Received #{type} message with payload #{msg}")
    {:ok, state}
  end

  def handle_cast({:send, {type, msg} = frame}, state) do
    Logger.debug("[Echo] Sending #{type} frame with payload: #{msg}")
    {:reply, frame, state}
  end

  def handle_disconnect(%{reason: {:local, reason}}, state) do
    Logger.debug("[Quackr] Local close with reason: #{inspect(reason)}")
    {:ok, state}
  end

  def handle_disconnect(disconnect_map, state) do
    super(disconnect_map, state)
  end
end
