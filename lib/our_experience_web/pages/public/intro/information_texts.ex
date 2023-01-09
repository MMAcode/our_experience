defmodule OurExperienceWeb.Pages.Public.Intro.InformationTexts do
  use Phoenix.Component

  def introduction(assigns) do
    ~H"""
    <br />
    <h3>Introduction</h3>
    <br />
    <p>
      Purpose of this project is to be able to <strong>compare effectivity of various behaviour strategies</strong>.
      For example, there are hundreds of ways to lose weight, many strategies to get rid of stress, to improve relationships or to combat depression.
      This project aims to be able to Which strategies are more effective than others, also considering the fact that some strategies may be effective for some people and other strategies for others.
    </p>
    <br />
    <p>
      This is a very ambitious goal, maybe impossible, but I believe it is worth trying to pursue.
      <%!-- If you want to know more about this <strong>larger vision</strong> --%>
      <%!-- in general and various considerations (EG ways to collect data, to attract users, to scale, to make profit), you can read about it later here. --%>
    </p>
    <br />
    <p>
      To break this project into smaller parts, for now this website will focus only on strategies whose purpose is to improve the
      <strong>quality of experience</strong>
      (happiness, life satisfaction, meaning and so on).
    </p>
    <br />
    <p>
      There are multiple strategies tested by science and one of the well documented ones and overall well respected is a so-called <strong>gratitude journal</strong>.
      Multiple scientific research shows that gratitude journaling, if done well, does boost once happiness significantly and consistently.
      To stay realistic we may expect our happiness to improve by 10% after 6 months but this effect appears long lasting.
    </p>
    <br/>
    <p>Comming Soon: <br/> <strong> Themed Gratitude Journal 'application'</strong> will be added to this website within next few months for anyone to use and rate. </p>
    <p></p>
    <p></p>
    """
  end
end
