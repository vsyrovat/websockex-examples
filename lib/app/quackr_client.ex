defmodule App.QuackrClient do
  use WebSockex
  require Logger

  @url "wss://s-usc1b-nss-2108.firebaseio.com/.ws?v=5&ns=quackr-31041"
  @keep_alive_ttl 45_000
  @init_frame ~S({"t":"d","d":{"r":1,"a":"q","b":{"p":"/messages","q":{"l":10,"vf":"r","i":".key"},"t":1,"h":""}}})

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
    Logger.debug("[Quackr] Connected")
    WebSockex.cast(self(), {:send, {:text, @init_frame}})
    Process.send_after(self(), :keep_alive, @keep_alive_ttl)
    {:ok, state}
  end

  def handle_frame({type, msg} = _frame, state) do
    Logger.debug("[Quackr] Received #{type} message with payload #{msg}")
    {:ok, state}
  end

  def handle_cast({:send, {type, msg} = frame}, state) do
    Logger.debug("[Quackr] Sending #{type} message with payload \"#{msg}\"")
    {:reply, frame, state}
  end

  def handle_info(:keep_alive, state) do
    WebSockex.cast(self(), {:send, {:text, "0"}})
    Process.send_after(self(), :keep_alive, @keep_alive_ttl)
    {:ok, state}
  end

  def handle_disconnect(%{reason: {:local, reason}}, state) do
    Logger.debug("[Quackr] Local close with reason: #{inspect(reason)}")
    {:ok, state}
  end

  def handle_disconnect(disconnect_map, state) do
    super(disconnect_map, state)
  end
end
