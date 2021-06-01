defmodule EdukatorWeb.Schema do
  @moduledoc false
  use Absinthe.Schema

  alias EdukatorWeb.Data

  import_types(Absinthe.Type.Custom)
  import_types(EdukatorWeb.Schema.UserTypes)
  import_types(EdukatorWeb.Schema.ExamTypes)
  import_types(EdukatorWeb.Schema.ExamSessionTypes)
  import_types(EdukatorWeb.Schema.QuestionTypes)
  import_types(EdukatorWeb.Schema.TrainingTypes)
  import_types(EdukatorWeb.Schema.ResponseTypes)
  import_types(EdukatorWeb.Schema.SessionTypes)
  import_types(EdukatorWeb.Schema.NotificationTypes)

  query do
    import_fields(:user_queries)
    import_fields(:exam_session_queries)
    import_fields(:question_queries)
    import_fields(:training_queries)
    import_fields(:session_queries)
    import_fields(:exam_queries)
    import_fields(:notification_queries)
  end

  mutation do
    import_fields(:user_mutations)
    import_fields(:exam_session_mutations)
    import_fields(:response_mutations)
    import_fields(:training_mutations)
    import_fields(:session_mutations)
    import_fields(:notification_mutations)
  end

  # subscription do
  #   # import_fields(:comment_subscriptions)
  #   # import_fields(:conversation_subscriptions)
  #   # import_fields(:message_subscriptions)
  #   # import_fields(:page_subscriptions)
  # end

  def context(ctx) do
    loader =
      Dataloader.new()
      |> Dataloader.add_source(Data, Data.data())

    Map.put(ctx, :loader, loader)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end

  # def middleware(middleware, _field, _object) do
  #   [NewRelic.Absinthe.Middleware] ++ middleware
  # end
end
