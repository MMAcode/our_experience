defmodule OurExperienceWeb.WeeklyTopicLiveTest do
  use OurExperienceWeb.ConnCase

  import Phoenix.LiveViewTest
  import OurExperience.Strategies.Journals.Gratitude.ThemedGratitudeJournal.WeeklyTopicsFixtures

  @create_attrs %{content: "some content", default_active_status: true, default_position: 42, title: "some title"}
  @update_attrs %{content: "some updated content", default_active_status: false, default_position: 43, title: "some updated title"}
  @invalid_attrs %{content: nil, default_active_status: false, default_position: nil, title: nil}

  defp create_weekly_topic(_) do
    weekly_topic = weekly_topic_fixture()
    %{weekly_topic: weekly_topic}
  end

  describe "Index" do
    setup [:create_weekly_topic]

    test "lists all weekly_topics", %{conn: conn, weekly_topic: weekly_topic} do
      {:ok, _index_live, html} = live(conn, ~p"/admin/weekly_topics")

      assert html =~ "Listing Weekly topics"
      assert html =~ weekly_topic.content
    end

    test "saves new weekly_topic", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/admin/weekly_topics")

      assert index_live |> element("a", "New Weekly topic") |> render_click() =~
               "New Weekly topic"

      assert_patch(index_live, ~p"/admin/weekly_topics/new")

      assert index_live
             |> form("#weekly_topic-form", weekly_topic: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#weekly_topic-form", weekly_topic: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/admin/weekly_topics")

      assert html =~ "Weekly topic created successfully"
      assert html =~ "some content"
    end

    test "updates weekly_topic in listing", %{conn: conn, weekly_topic: weekly_topic} do
      {:ok, index_live, _html} = live(conn, ~p"/admin/weekly_topics")

      assert index_live |> element("#weekly_topics-#{weekly_topic.id} a", "Edit") |> render_click() =~
               "Edit Weekly topic"

      assert_patch(index_live, ~p"/admin/weekly_topics/#{weekly_topic}/edit")

      assert index_live
             |> form("#weekly_topic-form", weekly_topic: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#weekly_topic-form", weekly_topic: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/admin/weekly_topics")

      assert html =~ "Weekly topic updated successfully"
      assert html =~ "some updated content"
    end

    test "deletes weekly_topic in listing", %{conn: conn, weekly_topic: weekly_topic} do
      {:ok, index_live, _html} = live(conn, ~p"/admin/weekly_topics")

      assert index_live |> element("#weekly_topics-#{weekly_topic.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#weekly_topic-#{weekly_topic.id}")
    end
  end

  describe "Show" do
    setup [:create_weekly_topic]

    test "displays weekly_topic", %{conn: conn, weekly_topic: weekly_topic} do
      {:ok, _show_live, html} = live(conn, ~p"/admin/weekly_topics/#{weekly_topic}")

      assert html =~ "Show Weekly topic"
      assert html =~ weekly_topic.content
    end

    test "updates weekly_topic within modal", %{conn: conn, weekly_topic: weekly_topic} do
      {:ok, show_live, _html} = live(conn, ~p"/admin/weekly_topics/#{weekly_topic}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Weekly topic"

      assert_patch(show_live, ~p"/admin/weekly_topics/#{weekly_topic}/show/edit")

      assert show_live
             |> form("#weekly_topic-form", weekly_topic: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#weekly_topic-form", weekly_topic: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/admin/weekly_topics/#{weekly_topic}")

      assert html =~ "Weekly topic updated successfully"
      assert html =~ "some updated content"
    end
  end
end
