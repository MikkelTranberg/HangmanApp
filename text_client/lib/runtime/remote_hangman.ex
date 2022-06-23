defmodule TextClient.Runtime.RemoteHangman do

@remote_server :hangman@trovelspc

def connect() do
 :rpc.call(@remote_server, Hangman, :new_game, [])
end
end
