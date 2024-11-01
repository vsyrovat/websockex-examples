# WebSockex usage example

Two websocket clients built with [WebSockex](https://github.com/Azolo/websockex).

Start:

```bash
iex -S mix
```

## App.EchoClient

Connects to `wss://echo.websocket.org`.

Start the client:

```elixir
App.EchoClient.start_link()
```

Send and receive any message:

``` elixir
App.EchoClient.send_text("HELLO")
```

You will receive "HELO" message from the websocket server.

Stop and reconnect the client:

```elixir
App.EchoClient.send_text("close")
```

## App.QuackrClient

`quackr.io` has a free sms numbers handled by Firebase Realtime Database.
This client connects to `firebase.io` and receives sms events from it like a browser does it.
Uses keep-alive messages.

Start the client:

```elixir
App.QuackrClient.start_link()
```

That's all. Now watch for debug messages in the console.
