defmodule Edukator.Accounts do
  @moduledoc false
  alias Edukator.Accounts.User
  alias Edukator.Admin.CDN
  alias Edukator.Repo

  import Edukator.TokenGenerator, only: [friendly_token: 0]

  def create(args, tenant \\ "public") do
    %User{}
    |> User.create_changeset(args)
    |> Repo.insert(prefix: tenant)
  end

  def create!(args, tenant \\ "public") do
    password = if Map.get(args, :password), do: args.password, else: friendly_token()

    args = Map.put(args, :password, password)

    %User{}
    |> User.create_changeset(args)
    |> Repo.insert!(prefix: tenant)
  end

  def get_user_by!(clauses, tenant \\ "public") do
    Repo.get_by!(User, clauses, prefix: tenant)
  end

  def get_user_by_email(email, tenant \\ "public") do
    User
    |> Repo.get_by([email: email], prefix: tenant)
    |> case do
      nil ->
        {:error, "Login error."}

      user ->
        {:ok, user}
    end
    |> add_profile_image_url(tenant)
  end

  def get_user_by_id(id, tenant \\ "public") do
    User
    |> Repo.get(id, prefix: tenant)
    |> case do
      nil -> {:error, "Not found"}
      user -> {:ok, user}
    end
    |> add_profile_image_url(tenant)
  end

  def update_user(user, params, tenant \\ "public") do
    user
    |> User.update_user_changeset(params)
    |> Repo.update(prefix: tenant)
    |> add_profile_image_url(tenant)
  end

  def update_password(user, params, tenant \\ "public") do
    user
    |> User.update_password_changeset(params)
    |> Repo.update(prefix: tenant)
  end

  def update_auth_token!(%User{} = user, auth_token, tenant \\ "public") do
    user
    |> User.external_auth_token_changeset(auth_token)
    |> Repo.update!(prefix: tenant)
  end

  def get_or_create_user(%{name: name, email: email} = args, tenant \\ "public") do
    password = if Map.get(args, :password), do: args.password, else: friendly_token()

    case get_user_by_email(email, tenant) do
      {:ok, user} -> {:ok, user}
      {:error, _} -> create(%{name: name, email: email, password: password}, tenant)
    end
  end

  def update_or_create_user(%{email: email} = args, tenant \\ "public") do
    case get_user_by_email(email, tenant) do
      {:ok, user} -> update_user(user, args, tenant)
      {:error, _} -> create(args, tenant)
    end
  end

  def add_profile_image_url({:error, _} = res, _tenant), do: res

  def add_profile_image_url({:ok, %{profile_image_data: %{id: path}} = user}, tenant)
      when not is_nil(path) do
    profile_image_url = CDN.get_cdn_image_url(tenant, path)

    {:ok, %{user | profile_image_url: profile_image_url}}
  end

  def add_profile_image_url({:ok, user}, _tenant), do: {:ok, user}

  def update_answered_questions_for_popup(user, tenant \\ "public")

  def update_answered_questions_for_popup(%{account_type: "TRIAL"} = user, tenant) do
    answered_questions_for_popup = user.answered_questions_for_popup + 1

    if answered_questions_for_popup == 30 do
      user
      |> update_user(%{answered_questions_for_popup: 0}, tenant)
    else
      user
      |> update_user(%{answered_questions_for_popup: answered_questions_for_popup}, tenant)
    end
  end

  def update_answered_questions_for_popup(user, _tenant), do: {:ok, user}

  def show_trial_invitation?({:ok, %{account_type: "TRIAL"} = user}) do
    user.answered_questions_for_popup == 0
  end

  def show_trial_invitation?({:ok, _user}), do: false

  @spec validate_trial_expiration_date(any) :: :ok | {:error, :trial_expired}
  def validate_trial_expiration_date(%{
        account_type: "TRIAL",
        trial_expiration_date: trial_expiration_date
      }) do
    trial_expiration_date =
      case trial_expiration_date do
        %Date{} -> trial_expiration_date
        _ -> Timex.parse!(trial_expiration_date, "{YYYY}-{0M}-{D}")
      end

    today = "America/Sao_Paulo" |> Timex.now() |> Timex.to_date()

    if Timex.compare(today, trial_expiration_date, :days) == 1 do
      {:error, :trial_expired}
    else
      :ok
    end
  end

  def validate_trial_expiration_date(_), do: :ok
end
