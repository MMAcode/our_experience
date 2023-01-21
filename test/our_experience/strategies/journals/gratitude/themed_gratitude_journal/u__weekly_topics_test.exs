defmodule OurExperience.Strategies.Journals.Gratitude.ThemedGratitudeJournal.U_WeeklyTopics.U_WeeklyTopicsTest do
  use OurExperience.DataCase

  alias OurExperience.Strategies.Journals.Gratitude.ThemedGratitudeJournal.U_WeeklyTopics.U_WeeklyTopics

  describe "u_weekly_topics" do
    alias OurExperience.Strategies.Journals.Gratitude.ThemedGratitudeJournal.U_WeeklyTopics.U_WeeklyTopic

    import OurExperience.Strategies.Journals.Gratitude.ThemedGratitudeJournal.U_WeeklyTopicsFixtures

    @invalid_attrs %{active: nil, position: nil}

    test "list_u_weekly_topics/0 returns all u_weekly_topics" do
      u__weekly_topic = u__weekly_topic_fixture()
      assert U_WeeklyTopics.list_u_weekly_topics() == [u__weekly_topic]
    end

    test "get_u__weekly_topic!/1 returns the u__weekly_topic with given id" do
      u__weekly_topic = u__weekly_topic_fixture()
      assert U_WeeklyTopics.get_u__weekly_topic!(u__weekly_topic.id) == u__weekly_topic
    end

    test "create_u__weekly_topic/1 with valid data creates a u__weekly_topic" do
      valid_attrs = %{active: true, position: 42}

      assert {:ok, %U_WeeklyTopic{} = u__weekly_topic} =
               U_WeeklyTopics.create_u__weekly_topic(valid_attrs)

      assert u__weekly_topic.active == true
      assert u__weekly_topic.position == 42
    end

    test "create_u__weekly_topic/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = U_WeeklyTopics.create_u__weekly_topic(@invalid_attrs)
    end

    test "update_u__weekly_topic/2 with valid data updates the u__weekly_topic" do
      u__weekly_topic = u__weekly_topic_fixture()
      update_attrs = %{active: false, position: 43}

      assert {:ok, %U_WeeklyTopic{} = u__weekly_topic} =
               U_WeeklyTopics.update_u__weekly_topic(u__weekly_topic, update_attrs)

      assert u__weekly_topic.active == false
      assert u__weekly_topic.position == 43
    end

    test "update_u__weekly_topic/2 with invalid data returns error changeset" do
      u__weekly_topic = u__weekly_topic_fixture()

      assert {:error, %Ecto.Changeset{}} =
               U_WeeklyTopics.update_u__weekly_topic(u__weekly_topic, @invalid_attrs)

      assert u__weekly_topic == U_WeeklyTopics.get_u__weekly_topic!(u__weekly_topic.id)
    end

    test "delete_u__weekly_topic/1 deletes the u__weekly_topic" do
      u__weekly_topic = u__weekly_topic_fixture()
      assert {:ok, %U_WeeklyTopic{}} = U_WeeklyTopics.delete_u__weekly_topic(u__weekly_topic)

      assert_raise Ecto.NoResultsError, fn ->
        U_WeeklyTopics.get_u__weekly_topic!(u__weekly_topic.id)
      end
    end

    test "change_u__weekly_topic/1 returns a u__weekly_topic changeset" do
      u__weekly_topic = u__weekly_topic_fixture()
      assert %Ecto.Changeset{} = U_WeeklyTopics.change_u__weekly_topic(u__weekly_topic)
    end
  end
end
