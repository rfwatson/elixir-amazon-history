defmodule AmazonHistory.Scraper do
  @base_url "https://www.amazon.co.uk"
  @order_url "#{@base_url}/gp/your-account/order-history?opt=ab&digitalOrders=1&unifiedOrders=1&returnTo=&orderFilter=year-"
  @end_year DateTime.utc_now.year
  @orders_per_page 10

  require Logger
  use Hound.Helpers

  def fetch(email, password, start_year) do
    Hound.start_session()

    login(email, password)

    Logger.info("Logged in successfully. Scraping with start_year: #{start_year}")

    items = Enum.reduce(start_year..@end_year, [], fn year, acc ->
      acc ++ process_year(year, 0, [])
    end)

    Hound.end_session()

    items
  end

  defp login(email, password) do
    navigate_to(@base_url)

    find_element(:id, "nav-link-yourAccount")
    |> click

    find_element(:id, "ap_email")
    |> fill_field(email)

    find_element(:id, "continue")
    |> click

    find_element(:id, "ap_password")
    |> fill_field(password)

    find_element(:id, "signInSubmit")
    |> click
  end

  defp process_year(year, startIndex, items) do
    order_url(year, startIndex)
    |> navigate_to

    find_element(:id, "ordersContainer")
    |> find_all_within_element(:class, "order")
    |> process_order_elements(year, startIndex, items)
  end

  defp order_url(year, startIndex) do
    @order_url <> to_string(year) <> "&startIndex=" <> to_string(startIndex)
  end

  defp process_order_elements([], _year, _startIndex, items) do
    items
  end

  defp process_order_elements(order_elements, year, startIndex, items) do
    new_items = Enum.reduce(order_elements, [], fn order_element, acc ->
      acc ++ process_order_element(order_element)
    end)

    process_year(year, startIndex + @orders_per_page, items ++ new_items)
  end

  defp process_order_element(order_element) do
    order_placed = extract_order_placed(order_element)
    order_number = extract_order_number(order_element)
    total = extract_total(order_element)

    find_all_within_element(order_element, :class, "a-link-normal")
    |> Enum.map(&(to_row(&1, order_placed, order_number, total)))
    |> Enum.filter(&is_valid_row?/1)
  end

  defp extract_order_placed(order_element) do
    find_within_element(order_element, :xpath, "//span[@class='a-color-secondary value']")
    |> inner_text
  end

  defp extract_order_number(order_element) do
    find_within_element(order_element, :xpath, "(//span[@class='a-color-secondary value'])[3]")
    |> inner_text
  end

  defp extract_total(order_element) do
    order_element
    |> search_within_element(:class, "a-color-price", 1)
    |> total_or_empty_string
  end

  defp total_or_empty_string({:ok, element}) do
    inner_text(element)
  end

  defp total_or_empty_string({:error, _}) do
    ""
  end

  defp to_row(item_element, order_placed, order_number, total) do
    name = inner_text(item_element)
    url = attribute_value(item_element, :href)

    [ order_number, order_placed, name, total, url ]
  end

  defp is_valid_row?([_order_number, _order_placed, name, _total, url])  do
    String.trim(name) != "" && String.contains?(url, "gp/product")
  end
end
