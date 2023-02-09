defmodule OurExperience.CONSTANTS do
  # eg:  dbg CONSTANTS.u_strategies.status.off
  def strategies do
    %{
      name: %{
        themed_gratitude_journal: "Themed Gratitude Journal"
      }
    }
  end

  def u_strategies do
    %{
      status: %{
        on: "on",
        off: "off"
      }
    }
  end

  def weekly_topics do
    %{
      stages: %{
        prepare: "prepare",
        review: "review", #may be
        partially_public_prototype: "partially_public_prototype", #may be
        public: "public"
      }
    }
  end

  def url_paths do
    %{
      base_for: %{
        u_weekly_topics: "my_experience"
      }
    }
  end
end
