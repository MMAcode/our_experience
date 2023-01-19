defmodule OurExperienceWeb.U_WeeklyTopicLiveTest do
  use OurExperienceWeb.ConnCase

  import Phoenix.LiveViewTest
  import OurExperience.Strategies.Journals.Gratitude.ThemedGratitudeJournal.U_WeeklyTopicsFixtures

  @create_attrs %{active: true, position: 42}
  @update_attrs %{active: false, position: 43}
  @invalid_attrs %{active: false, position: nil}

  defp create_u__weekly_topic(_) do
    u__weekly_topic = u__weekly_topic_fixture()
    %{u__weekly_topic: u__weekly_topic}
  end

  describe "Index" do
    setup [:create_u__weekly_topic]

    test "lists all u_weekly_topics", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/u_weekly_topics")

      assert html =~ "Listing U weekly topics"
    end

    test "saves new u__weekly_topic", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/u_weekly_topics")

      assert index_live |> element("a", "New U  weekly topic") |> render_click() =~
               "New U  weekly topic"

      assert_patch(index_live, ~p"/u_weekly_topics/new")

      assert index_live
             |> form("#u__weekly_topic-form", u__weekly_topic: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#u__weekly_topic-form", u__weekly_topic: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/u_weekly_topics")

      assert html =~ "U  weekly topic created successfully"
    end

    test "updates u__weekly_topic in listing", %{conn: conn, u__weekly_topic: u__weekly_topic} do
      {:ok, index_live, _html} = live(conn, ~p"/u_weekly_topics")

      assert index_live
             |> element("#u_weekly_topics-#{u__weekly_topic.id} a", "Edit")
             |> render_click() =~
               "Edit U  weekly topic"

      assert_patch(index_live, ~p"/u_weekly_topics/#{u__weekly_topic}/edit")

      assert index_live
             |> form("#u__weekly_topic-form", u__weekly_topic: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#u__weekly_topic-form", u__weekly_topic: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/u_weekly_topics")

      assert html =~ "U  weekly topic updated successfully"
    end

    test "deletes u__weekly_topic in listing", %{conn: conn, u__weekly_topic: u__weekly_topic} do
      {:ok, index_live, _html} = live(conn, ~p"/u_weekly_topics")

      assert index_live
             |> element("#u_weekly_topics-#{u__weekly_topic.id} a", "Delete")
             |> render_click()

      refute has_element?(index_live, "#u__weekly_topic-#{u__weekly_topic.id}")
    end
  end

  describe "Show" do
    setup [:create_u__weekly_topic]

    test "displays u__weekly_topic", %{conn: conn, u__weekly_topic: u__weekly_topic} do
      {:ok, _show_live, html} = live(conn, ~p"/u_weekly_topics/#{u__weekly_topic}")

      assert html =~ "Show U  weekly topic"
    end

    test "updates u__weekly_topic within modal", %{conn: conn, u__weekly_topic: u__weekly_topic} do
      {:ok, show_live, _html} = live(conn, ~p"/u_weekly_topics/#{u__weekly_topic}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit U  weekly topic"

      assert_patch(show_live, ~p"/u_weekly_topics/#{u__weekly_topic}/show/edit")

      assert show_live
             |> form("#u__weekly_topic-form", u__weekly_topic: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#u__weekly_topic-form", u__weekly_topic: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/u_weekly_topics/#{u__weekly_topic}")

      assert html =~ "U  weekly topic updated successfully"
    end
  end
end
