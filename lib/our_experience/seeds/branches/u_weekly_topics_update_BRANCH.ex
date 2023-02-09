defmodule OurExperience.Seeds.Branches.UWeeklyTopicsUpdate_BRANCH do
  alias OurExperience.CONSTANTS
  alias OurExperience.Strategies.Strategy
  alias OurExperience.Repo
  alias OurExperienceWeb.Pages.GratitudeJournal.ThemedGratitudeJournalPrivate

  alias OurExperience.Strategies.Journals.Gratitude.ThemedGratitudeJournal.U_WeeklyTopics.U_WeeklyTopic

  alias OurExperience.Strategies.Journals.Gratitude.ThemedGratitudeJournal.WeeklyTopics.WeeklyTopics

  import Ecto.Query
# delete bad weekly topics first;
# update this to load only active weekly topics!, not those in dev
  # mix run priv/repo/branches.exs
  def update_user_weekly_topics() do


    # get all weekly topics
    wt_ids = WeeklyTopics.list_all_public_ids()

    # 1)
    users =
      Repo.all(
        from u in OurExperience.Users.User,
          join: u_s in assoc(u, :u_strategies),
          on: u_s.status == "on",
          join: s in assoc(u_s, :strategy),
          where: s.name == "Themed Gratitude Journal",
          where: u_s.status == ^CONSTANTS.u_strategies().status.on,
          left_join: u_wt in assoc(u_s, :u_weekly_topics),
          preload: [u_strategies: {u_s, strategy: s, u_weekly_topics: u_wt}]
      )

    dbg "users ids:"
    Enum.each(users, &dbg(&1.id))
    # 2)

    maps_with_results = users
    |> Stream.map(fn user ->
      str = ThemedGratitudeJournalPrivate.get_active_TGJ_uStrategy_fromLoadedData(user)
      u_wt = Map.get(str, :u_weekly_topics, [])
      # get size of u_wt
      u_wt_size = Enum.count(u_wt)
      u_wt_highest_position = u_wt |> Enum.max_by(fn u_wt -> u_wt.position end) |> Map.get(:position, 0)

      wt_ids_on_user = u_wt |> Enum.map(fn u_wt -> u_wt.weekly_topic_id end)
      missing_wt_ids = get_missing_wt_ids(wt_ids, wt_ids_on_user)
      new_inserted_u_wts =
        missing_wt_ids
        |> Enum.with_index(fn id, i ->
          # dbg([i, id])
          # dbg((u_wt_size + i))
          %{id: id, index: i}
        end)
        |> Enum.map(fn x -> dbg(x) end)
        |> Enum.map(
          &%U_WeeklyTopic{
            active: false,
            position: (u_wt_highest_position + 1 + &1.index),
            user_id: user.id,
            u_strategy_id: str.id,
            weekly_topic_id: &1.id
          }
        )
       |> Enum.map(&Repo.insert!(&1))

      # results = Repo.insert_all(U_WeeklyTopic, new_u_wts)

      _result = %{
        u_id: user.id,
        u_str_id: str.id,
        missing_wt_ids: missing_wt_ids,
        nr_of_existing_u_wt: u_wt_size,
        result_new_inserted_u_WTs: new_inserted_u_wts
      }
    end)
    |> Enum.to_list()

    dbg maps_with_results
    # |> dbg
  end

  defp get_missing_wt_ids(wt_ids, wt_ids_on_user) do
    wt_ids |> Enum.filter(fn wt_id -> !Enum.member?(wt_ids_on_user, wt_id) end)
  end
end
