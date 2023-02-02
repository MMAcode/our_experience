defmodule OurExperience.Strategies.Journals.Gratitude.ThemedGratitudeJournal.U_Journal_EntriesTest do
  use OurExperience.DataCase

  alias OurExperience.Strategies.Journals.Gratitude.ThemedGratitudeJournal.U_Journal_Entries

  describe "u_journal_entries" do
    alias OurExperience.Strategies.Journals.Gratitude.ThemedGratitudeJournal.U_Journal_Entries.U_Journal_Entry

    import OurExperience.Strategies.Journals.Gratitude.ThemedGratitudeJournal.U_Journal_EntriesFixtures

    @invalid_attrs %{content: nil}

    test "list_u_journal_entries/0 returns all u_journal_entries" do
      u__journal__entry = u__journal__entry_fixture()
      assert U_Journal_Entries.list_u_journal_entries() == [u__journal__entry]
    end

    test "get_u__journal__entry!/1 returns the u__journal__entry with given id" do
      u__journal__entry = u__journal__entry_fixture()
      assert U_Journal_Entries.get_u__journal__entry!(u__journal__entry.id) == u__journal__entry
    end

    test "create_u__journal__entry/1 with valid data creates a u__journal__entry" do
      valid_attrs = %{content: %{}}

      assert {:ok, %U_Journal_Entry{} = u__journal__entry} = U_Journal_Entries.create_u__journal__entry(valid_attrs)
      assert u__journal__entry.content == %{}
    end

    test "create_u__journal__entry/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = U_Journal_Entries.create_u__journal__entry(@invalid_attrs)
    end

    test "update_u__journal__entry/2 with valid data updates the u__journal__entry" do
      u__journal__entry = u__journal__entry_fixture()
      update_attrs = %{content: %{}}

      assert {:ok, %U_Journal_Entry{} = u__journal__entry} = U_Journal_Entries.update_u__journal__entry(u__journal__entry, update_attrs)
      assert u__journal__entry.content == %{}
    end

    test "update_u__journal__entry/2 with invalid data returns error changeset" do
      u__journal__entry = u__journal__entry_fixture()
      assert {:error, %Ecto.Changeset{}} = U_Journal_Entries.update_u__journal__entry(u__journal__entry, @invalid_attrs)
      assert u__journal__entry == U_Journal_Entries.get_u__journal__entry!(u__journal__entry.id)
    end

    test "delete_u__journal__entry/1 deletes the u__journal__entry" do
      u__journal__entry = u__journal__entry_fixture()
      assert {:ok, %U_Journal_Entry{}} = U_Journal_Entries.delete_u__journal__entry(u__journal__entry)
      assert_raise Ecto.NoResultsError, fn -> U_Journal_Entries.get_u__journal__entry!(u__journal__entry.id) end
    end

    test "change_u__journal__entry/1 returns a u__journal__entry changeset" do
      u__journal__entry = u__journal__entry_fixture()
      assert %Ecto.Changeset{} = U_Journal_Entries.change_u__journal__entry(u__journal__entry)
    end
  end
end
