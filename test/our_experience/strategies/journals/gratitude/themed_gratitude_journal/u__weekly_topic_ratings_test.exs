defmodule OurExperience.Strategies.Journals.Gratitude.ThemedGratitudeJournal.U_WeeklyTopicRatingsTest do
  use OurExperience.DataCase

  alias OurExperience.Strategies.Journals.Gratitude.ThemedGratitudeJournal.U_WeeklyTopicRatings

  describe "u_weekly_topic_ratings" do
    alias OurExperience.Strategies.Journals.Gratitude.ThemedGratitudeJournal.U_WeeklyTopicRatings.U_WeeklyTopicRating

    import OurExperience.Strategies.Journals.Gratitude.ThemedGratitudeJournal.U_WeeklyTopicRatingsFixtures

    @invalid_attrs %{after_first_view: nil, after_first_week: nil, manual_activations: nil}

    test "list_u_weekly_topic_ratings/0 returns all u_weekly_topic_ratings" do
      u__weekly_topic_rating = u__weekly_topic_rating_fixture()
      assert U_WeeklyTopicRatings.list_u_weekly_topic_ratings() == [u__weekly_topic_rating]
    end

    test "get_u__weekly_topic_rating!/1 returns the u__weekly_topic_rating with given id" do
      u__weekly_topic_rating = u__weekly_topic_rating_fixture()
      assert U_WeeklyTopicRatings.get_u__weekly_topic_rating!(u__weekly_topic_rating.id) == u__weekly_topic_rating
    end

    test "create_u__weekly_topic_rating/1 with valid data creates a u__weekly_topic_rating" do
      valid_attrs = %{after_first_view: %{}, after_first_week: %{}, manual_activations: %{}}

      assert {:ok, %U_WeeklyTopicRating{} = u__weekly_topic_rating} = U_WeeklyTopicRatings.create_u__weekly_topic_rating(valid_attrs)
      assert u__weekly_topic_rating.after_first_view == %{}
      assert u__weekly_topic_rating.after_first_week == %{}
      assert u__weekly_topic_rating.manual_activations == %{}
    end

    test "create_u__weekly_topic_rating/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = U_WeeklyTopicRatings.create_u__weekly_topic_rating(@invalid_attrs)
    end

    test "update_u__weekly_topic_rating/2 with valid data updates the u__weekly_topic_rating" do
      u__weekly_topic_rating = u__weekly_topic_rating_fixture()
      update_attrs = %{after_first_view: %{}, after_first_week: %{}, manual_activations: %{}}

      assert {:ok, %U_WeeklyTopicRating{} = u__weekly_topic_rating} = U_WeeklyTopicRatings.update_u__weekly_topic_rating(u__weekly_topic_rating, update_attrs)
      assert u__weekly_topic_rating.after_first_view == %{}
      assert u__weekly_topic_rating.after_first_week == %{}
      assert u__weekly_topic_rating.manual_activations == %{}
    end

    test "update_u__weekly_topic_rating/2 with invalid data returns error changeset" do
      u__weekly_topic_rating = u__weekly_topic_rating_fixture()
      assert {:error, %Ecto.Changeset{}} = U_WeeklyTopicRatings.update_u__weekly_topic_rating(u__weekly_topic_rating, @invalid_attrs)
      assert u__weekly_topic_rating == U_WeeklyTopicRatings.get_u__weekly_topic_rating!(u__weekly_topic_rating.id)
    end

    test "delete_u__weekly_topic_rating/1 deletes the u__weekly_topic_rating" do
      u__weekly_topic_rating = u__weekly_topic_rating_fixture()
      assert {:ok, %U_WeeklyTopicRating{}} = U_WeeklyTopicRatings.delete_u__weekly_topic_rating(u__weekly_topic_rating)
      assert_raise Ecto.NoResultsError, fn -> U_WeeklyTopicRatings.get_u__weekly_topic_rating!(u__weekly_topic_rating.id) end
    end

    test "change_u__weekly_topic_rating/1 returns a u__weekly_topic_rating changeset" do
      u__weekly_topic_rating = u__weekly_topic_rating_fixture()
      assert %Ecto.Changeset{} = U_WeeklyTopicRatings.change_u__weekly_topic_rating(u__weekly_topic_rating)
    end
  end
end
