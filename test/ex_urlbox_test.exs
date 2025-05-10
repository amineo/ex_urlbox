defmodule ExUrlboxTest do
  use ExUnit.Case, async: false
  alias ExUrlbox.Utils

  doctest ExUrlbox

  @test_url "https://google.com"
  @test_options [
    format: "png",
    width: 1024,
    height: 768
  ]

  @assembled_request_url "https://api.urlbox.io/v1/fakeAPIkey/3e2c5515f8a2de570445a8b4b5c041809fb9b97e/png?url=https%3A%2F%2Fgoogle.com&width=1024&height=768"

  # Mock requests
  setup_all do
    Tesla.Mock.mock_global(fn
      %{method: :get} -> api_get_request()
      %{method: :post} -> api_post_request()
      %{method: :delete} -> api_delete_request()
      %{method: :head} -> api_head_request()
    end)
    :ok
  end





  test "[get] screenshot request" do
    {:ok, screenshot_request} = ExUrlbox.get(@test_url, @test_options)

    assert screenshot_request.url === @assembled_request_url
  end


  test "[post] screenshot request" do
    options = [{:webhook_url, "https://example.com/webook"} | @test_options]
    {:ok, screenshot_request} = ExUrlbox.post(@test_url, options)


    # Headers
    assert Tesla.get_headers(screenshot_request, "authorization") === ["Bearer #{Application.get_env(:ex_urlbox, :api_secret)}"]
    assert Tesla.get_headers(screenshot_request, "content-type") === ["application/json"]

    # Post API Endpoint
    assert screenshot_request.url === "https://api.urlbox.io/v1/render"

    # Body
    assert screenshot_request.body["url"] === "https://google.com"
    assert screenshot_request.body["webhook_url"] === "https://example.com/webook"
  end


  test "[head] screenshot request" do
    {:ok, screenshot_request} = ExUrlbox.head(@test_url, @test_options)

    assert screenshot_request.url === @assembled_request_url
  end


  test "[delete] screenshot request" do
    {:ok, screenshot_request} = ExUrlbox.delete(@test_url, @test_options)

    assert screenshot_request.url === @assembled_request_url
  end


  test "generate url token with hmac" do
    params = "url=https%3A%2F%2Fgoogle.com&width=1024&height=768"
    token = Utils.generate_url_token(params)

    assert token === "3e2c5515f8a2de570445a8b4b5c041809fb9b97e"
  end


  test "build url" do
    options = [{:url, @test_url} | @test_options]
    generated_url = Utils.build_url(options)

    assert generated_url === "3e2c5515f8a2de570445a8b4b5c041809fb9b97e/png?url=https%3A%2F%2Fgoogle.com&width=1024&height=768"
  end







  # Request Mocks
  defp api_get_request do
    %Tesla.Env{
      method: :get,
      url: @assembled_request_url
    }
  end

  defp api_post_request do
    %Tesla.Env{
      method: :post,
      body: "{\"format\":\"png\",\"height\":768,\"url\":\"https://google.com\",\"webhook_url\":\"https://example.com/webook\",\"width\":1024}",
      headers: [
        {"authorization", "Bearer fakeAPIsecret"},
        {"content-type", "application/json"}
      ],
      url: "https://api.urlbox.io/v1/render"
    }
  end

  defp api_delete_request do
    %Tesla.Env{
      method: :delete,
      url: @assembled_request_url
    }
  end

  defp api_head_request do
    %Tesla.Env{
      method: :head,
      url: @assembled_request_url
    }
  end

end
