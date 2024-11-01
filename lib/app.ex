defmodule App do
  use Application

  def start(_, _) do
    children = [
      # App.EchoClient,
      # App.QuackrClient
    ]

    opts = [strategy: :one_for_one, name: App.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
