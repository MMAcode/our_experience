defmodule OurExperience.Strategies.Journals.Gratitude.ThemedGratitudeJournal.U_Journal_Entries.U_Journal_Entries do
  @moduledoc """
  The Strategies.Journals.Gratitude.ThemedGratitudeJournal.U_Journal_Entries.U_Journal_Entries context.
  """

  import Ecto.Query, warn: false
  alias OurExperience.Repo

  alias OurExperience.Strategies.Journals.Gratitude.ThemedGratitudeJournal.U_Journal_Entries.U_Journal_Entry

  @doc """
  Returns the list of u_journal_entries.

  ## Examples

      iex> list_u_journal_entries()
      [%U_Journal_Entry{}, ...]

  """
  def list_u_journal_entries do
    Repo.all(U_Journal_Entry)
  end

  @doc """
  Gets a single u__journal__entry.

  Raises `Ecto.NoResultsError` if the U  journal  entry does not exist.

  ## Examples

      iex> get_u__journal__entry!(123)
      %U_Journal_Entry{}

      iex> get_u__journal__entry!(456)
      ** (Ecto.NoResultsError)

  """
  def get_u__journal__entry!(id), do: Repo.get!(U_Journal_Entry, id)

  @doc """
  Creates a u__journal__entry.

  ## Examples

      iex> create_u__journal__entry(%{field: value})
      {:ok, %U_Journal_Entry{}}

      iex> create_u__journal__entry(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create(attrs \\ %{}) do
    %U_Journal_Entry{}
    |> U_Journal_Entry.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a u__journal__entry.

  ## Examples

      iex> update_u__journal__entry(u__journal__entry, %{field: new_value})
      {:ok, %U_Journal_Entry{}}

      iex> update_u__journal__entry(u__journal__entry, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_u__journal__entry(%U_Journal_Entry{} = u__journal__entry, attrs) do
    u__journal__entry
    |> U_Journal_Entry.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a u__journal__entry.

  ## Examples

      iex> delete_u__journal__entry(u__journal__entry)
      {:ok, %U_Journal_Entry{}}

      iex> delete_u__journal__entry(u__journal__entry)
      {:error, %Ecto.Changeset{}}

  """
  def delete_u__journal__entry(%U_Journal_Entry{} = u__journal__entry) do
    Repo.delete(u__journal__entry)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking u__journal__entry changes.

  ## Examples

      iex> change_u__journal__entry(u__journal__entry)
      %Ecto.Changeset{data: %U_Journal_Entry{}}

  """
  def change_u__journal__entry(%U_Journal_Entry{} = u__journal__entry, attrs \\ %{}) do
    U_Journal_Entry.changeset(u__journal__entry, attrs)
  end
end
