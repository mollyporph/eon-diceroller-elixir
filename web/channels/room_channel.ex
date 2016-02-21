defmodule Mkeon.RoomChannel do
  use Mkeon.Web, :channel
  import RegexCase
  alias Mkeon.Diceroller
  def join("rooms:lobby", payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (rooms:lobby).
  def handle_in("shout", payload, socket) do
    broadcast socket, "shout", payload
    {:noreply, socket}
  end
  def handle_in("roll_dice", %{"dices"=> dicestring, "username" => username}, socket) do
    reg = ~r/(?<ob>ob)?(?<amount>\d{1,2})(?:t|d)(?<dice>\d{1,3})(?:\+(?<mod>\d{1,2}))?/i
    if Regex.match?(reg, dicestring) do
       %{"ob" => ob, "amount" => amount, "dice" => dice, "mod" =>mod} = Regex.named_captures(reg, dicestring)
        {parsedAmount, _} = Integer.parse(amount)
        {parsedDiceValue, _} = Integer.parse(dice)
        {roll, obcount} = case ob === "ob" do
         true ->
            Diceroller.roll_obdice(parsedAmount, parsedDiceValue)
         false ->
          { Diceroller.roll_normaldice(parsedAmount, parsedDiceValue), 0 }
       end
       response = %{:username => username,:original => dicestring, :roll => roll, :mod => mod, :obcount => obcount, :sum => Enum.sum(roll) }
       broadcast socket, "roll_dice", response
       {:noreply, socket}
      end
  end
  # This is invoked every time a notification is being broadcast
  # to the client. The default implementation is just to push it
  # downstream but one could filter or change the event.
  def handle_out(event, payload, socket) do
    push socket, event, payload
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
