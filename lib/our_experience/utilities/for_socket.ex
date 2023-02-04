defmodule OurExperience.Utilities.ForSocket do
    @doc """
  Adds a list of elements to a socket using a function that takes a socket and an element and returns a socket.
  @spec addFromListToSocket(socket, [item], (socket, item) -> socket) :: socket
  """
  def addFromListToSocket(socket, [el | tail], func0Rsocket) do
    socket = func0Rsocket.(socket, el)
    addFromListToSocket(socket, tail, func0Rsocket)
  end

  def addFromListToSocket(socket, [], _func0Rsocket), do: socket

end
