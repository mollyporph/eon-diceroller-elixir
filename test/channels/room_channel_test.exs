defmodule Mkeon.RoomChannelTest do
  use Mkeon.ChannelCase

  alias Mkeon.RoomChannel

  setup do
    {:ok, _, socket} =
      socket("user_id", %{some: :assign})
      |> subscribe_and_join(RoomChannel, "rooms:lobby")

    {:ok, socket: socket}
  end

  test "ping replies with status ok", %{socket: socket} do
    ref = push socket, "ping", %{"hello" => "there"}
    assert_reply ref, :ok, %{"hello" => "there"}
  end

  test "shout broadcasts to rooms:lobby", %{socket: socket} do
    push socket, "shout", %{"hello" => "all"}
    assert_broadcast "shout", %{"hello" => "all"}
  end
  test "roll_dice rolls dice and broadcasts to rooms:lobby", %{socket: socket} do
    push socket, "roll_dice", %{"username"=> "test", "dices" => "ob3t6+3"}
    assert_broadcast "roll_dice",  %{:username => "test",:original => "ob3t6+3", :roll => roll, :mod => "3", :obcount => obcount, :sum => sum}
    assert is_integer(obcount)
    assert is_integer(sum)
    assert is_list(roll)
  end
  test "broadcasts are pushed to the client", %{socket: socket} do
    broadcast_from! socket, "broadcast", %{"some" => "data"}
    assert_push "broadcast", %{"some" => "data"}
  end
end
