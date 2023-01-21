defmodule OurExperience.Strategies.Journals.Gratitude.ThemedGratitudeJournal.WeeklyTopics.WeeklyTopicsTest do
  use OurExperience.DataCase

  alias OurExperience.Strategies.Journals.Gratitude.ThemedGratitudeJournal.WeeklyTopics.WeeklyTopics

  describe "weekly_topics" do
    alias OurExperience.Strategies.Journals.Gratitude.ThemedGratitudeJournal.WeeklyTopics.WeeklyTopic

    import OurExperience.Strategies.Journals.Gratitude.ThemedGratitudeJournal.WeeklyTopicsFixtures

    @invalid_attrs %{content: nil, default_active_status: nil, default_position: nil, title: nil}

    test "list_weekly_topics/0 returns all weekly_topics" do
      weekly_topic = weekly_topic_fixture()
      assert WeeklyTopics.list_weekly_topics() == [weekly_topic]
    end

    test "get_weekly_topic!/1 returns the weekly_topic with given id" do
      weekly_topic = weekly_topic_fixture()
      assert WeeklyTopics.get_weekly_topic!(weekly_topic.id) == weekly_topic
    end

    test "create_weekly_topic/1 with valid data creates a weekly_topic" do
      valid_attrs = %{
        content: "some content",
        default_active_status: true,
        default_position: 42,
        title: "some title"
      }

      assert {:ok, %WeeklyTopic{} = weekly_topic} = WeeklyTopics.create_weekly_topic(valid_attrs)
      assert weekly_topic.content == "some content"
      assert weekly_topic.default_active_status == true
      assert weekly_topic.default_position == 42
      assert weekly_topic.title == "some title"
    end

    test "create_weekly_topic/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = WeeklyTopics.create_weekly_topic(@invalid_attrs)
    end

    test "update_weekly_topic/2 with valid data updates the weekly_topic" do
      weekly_topic = weekly_topic_fixture()

      update_attrs = %{
        content: "some updated content",
        default_active_status: false,
        default_position: 43,
        title: "some updated title"
      }

      assert {:ok, %WeeklyTopic{} = weekly_topic} =
               WeeklyTopics.update_weekly_topic(weekly_topic, update_attrs)

      assert weekly_topic.content == "some updated content"
      assert weekly_topic.default_active_status == false
      assert weekly_topic.default_position == 43
      assert weekly_topic.title == "some updated title"
    end

    test "update_weekly_topic/2 with invalid data returns error changeset" do
      weekly_topic = weekly_topic_fixture()

      assert {:error, %Ecto.Changeset{}} =
               WeeklyTopics.update_weekly_topic(weekly_topic, @invalid_attrs)

      assert weekly_topic == WeeklyTopics.get_weekly_topic!(weekly_topic.id)
    end

    test "delete_weekly_topic/1 deletes the weekly_topic" do
      weekly_topic = weekly_topic_fixture()
      assert {:ok, %WeeklyTopic{}} = WeeklyTopics.delete_weekly_topic(weekly_topic)
      assert_raise Ecto.NoResultsError, fn -> WeeklyTopics.get_weekly_topic!(weekly_topic.id) end
    end

    test "change_weekly_topic/1 returns a weekly_topic changeset" do
      weekly_topic = weekly_topic_fixture()
      assert %Ecto.Changeset{} = WeeklyTopics.change_weekly_topic(weekly_topic)
    end
  end
end
