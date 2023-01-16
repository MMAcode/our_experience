defmodule OurExperience.CONSTANTS do
  def u_strategies() do # eg:  dbg CONSTANTS.u_strategies.status.off
    %{status: %{
        on: "on",
        off: "off"}}
  end

  def url_paths() do
    %{base_for: %{
      u_weekly_topics: "my_experience"
    }}
  end
end
