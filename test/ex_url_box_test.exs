defmodule ExUrlboxTest do
  use ExUnit.Case, async: true
  doctest ExUrlbox

  test "Test get request for a screenshot" do
    url = "https://www.google.com"
    options = [
      format: "png",
      width: 1024,
      height: 768
    ]

    screenshot = ExUrlbox.get(url, options)
    # IO.inspect screenshot

    assert {:ok, screenshot} = screenshot
  end



end
