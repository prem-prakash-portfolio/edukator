defmodule Edukator.ExamsTest do
  use Edukator.DataCase
  import Edukator.Factory

  alias Edukator.Exams

  describe "list_exams/3" do
    test "should return exam list according to search text words" do
      insert(:exam, name: "FUNARTE FGV 2014 Técnico-Contrarregra")
      b = insert(:exam, name: "BACEN CESPE 2009 Procurador", year: 2017)
      c = insert(:exam, name: "TCE-BA CESPE 2010 Procurador", year: 2016)
      user = insert(:user)

      result =
        Exams.list_exams(
          %{type: OLD_EXAM, search_text: "CESPE Procurador", size: 5},
          user,
          "public"
        )

      assert Enum.map(result.exams, fn exam -> exam.id end) == [b.id, c.id]
    end

    test "should return exam list according to exam type" do
    end

    test "should search exams regardless of accents" do
      a = insert(:exam, name: "FUNARTE FGV 2014 Técnico-Contrarrêgra")
      user = insert(:user)

      result =
        Exams.list_exams(
          %{type: OLD_EXAM, search_text: "FUNAR tecnico contrarregra", size: 5},
          user,
          "public"
        )

      assert Enum.map(result.exams, fn exam -> exam.name end) == [a.name]
    end
  end

  describe "sessions_data" do
    test "should update mean accordingly" do
      exam =
        insert(:exam,
          exam_questions_count: 20,
          sessions_data: %{mean_percentage_correct: 10, finished_sessions_count: 2}
        )

      exam_session = insert(:exam_session, exam: exam, correct_questions_count: 16)
      {:ok, updated} = Exams.update_sessions_data(exam_session, "public")

      assert updated.sessions_data.mean_percentage_correct == 12

      assert updated.sessions_data.finished_sessions_count == 3
    end
  end

  #
  # describe "authors" do
  #   alias Edukator.Exams.Author
  #
  #   @valid_attrs %{name: "some name", slug: "some slug"}
  #   @update_attrs %{name: "some updated name", slug: "some updated slug"}
  #   @invalid_attrs %{name: nil, slug: nil}
  #
  #   def author_fixture(attrs \\ %{}) do
  #     {:ok, author} =
  #       attrs
  #       |> Enum.into(@valid_attrs)
  #       |> Exams.create_author()
  #
  #     author
  #   end
  #
  #   test "list_authors/0 returns all authors" do
  #     author = author_fixture()
  #     assert Exams.list_authors() == [author]
  #   end
  #
  #   test "get_author!/1 returns the author with given id" do
  #     author = author_fixture()
  #     assert Exams.get_author!(author.id) == author
  #   end
  #
  #   test "create_author/1 with valid data creates a author" do
  #     assert {:ok, %Author{} = author} = Exams.create_author(@valid_attrs)
  #     assert author.name == "some name"
  #     assert author.slug == "some slug"
  #   end
  #
  #   test "create_author/1 with invalid data returns error changeset" do
  #     assert {:error, %Ecto.Changeset{}} = Exams.create_author(@invalid_attrs)
  #   end
  #
  #   test "update_author/2 with valid data updates the author" do
  #     author = author_fixture()
  #     assert {:ok, %Author{} = author} = Exams.update_author(author, @update_attrs)
  #     assert author.name == "some updated name"
  #     assert author.slug == "some updated slug"
  #   end
  #
  #   test "update_author/2 with invalid data returns error changeset" do
  #     author = author_fixture()
  #     assert {:error, %Ecto.Changeset{}} = Exams.update_author(author, @invalid_attrs)
  #     assert author == Exams.get_author!(author.id)
  #   end
  #
  #   test "delete_author/1 deletes the author" do
  #     author = author_fixture()
  #     assert {:ok, %Author{}} = Exams.delete_author(author)
  #     assert_raise Ecto.NoResultsError, fn -> Exams.get_author!(author.id) end
  #   end
  #
  #   test "change_author/1 returns a author changeset" do
  #     author = author_fixture()
  #     assert %Ecto.Changeset{} = Exams.change_author(author)
  #   end
  # end
  #
  describe "list_organizations_and_jobs/1" do
    test "returns all organizations and jobs" do
      before_qty = Exams.list_organizations_and_jobs("public").organizations |> Enum.count()

      organizations_qty = Enum.random(1..5)
      insert_list(organizations_qty, :exam) |> Enum.map(& &1.job_id)

      assert Exams.list_organizations_and_jobs("public").organizations |> Enum.count() ==
               organizations_qty + before_qty
    end
  end

  describe "list_jobs/2" do
    test "returns all selected jobs" do
      exams = insert_list(5, :exam)
      jobs_ids = Enum.slice(exams, 0, 3) |> Enum.map(& &1.job_id)

      jobs_listed_ids = Exams.list_jobs(jobs_ids, "public") |> Enum.map(& &1.id) |> MapSet.new()

      ys_mapset = MapSet.new(jobs_listed_ids)
      assert Enum.all?(jobs_ids, fn x -> x in ys_mapset end) == true
    end
  end

  describe "list_organizations/2" do
    test "returns all selected organizations" do
      exams = insert_list(5, :exam)
      organizations_ids = Enum.slice(exams, 0, 3) |> Enum.map(& &1.organization_id)

      organizations_listed_ids =
        Exams.list_organizations(organizations_ids, "public") |> Enum.map(& &1.id) |> MapSet.new()

      ys_mapset = MapSet.new(organizations_listed_ids)
      assert Enum.all?(organizations_ids, fn x -> x in ys_mapset end) == true
    end
  end

  #
  # describe "exams" do
  #   alias Edukator.Exams.Exam
  #
  #   @valid_attrs %{area: "some area", edition: "some edition", exam_questions_count: 42, name: "some name", speciality: "some speciality", year: "some year"}
  #   @update_attrs %{area: "some updated area", edition: "some updated edition", exam_questions_count: 43, name: "some updated name", speciality: "some updated speciality", year: "some updated year"}
  #   @invalid_attrs %{area: nil, edition: nil, exam_questions_count: nil, name: nil, speciality: nil, year: nil}
  #
  #   def exam_fixture(attrs \\ %{}) do
  #     {:ok, exam} =
  #       attrs
  #       |> Enum.into(@valid_attrs)
  #       |> Exams.create_exam()
  #
  #     exam
  #   end
  #
  #   test "list_exams/0 returns all exams" do
  #     exam = exam_fixture()
  #     assert Exams.list_exams() == [exam]
  #   end
  #
  #   test "get_exam!/1 returns the exam with given id" do
  #     exam = exam_fixture()
  #     assert Exams.get_exam!(exam.id) == exam
  #   end
  #
  #   test "create_exam/1 with valid data creates a exam" do
  #     assert {:ok, %Exam{} = exam} = Exams.create_exam(@valid_attrs)
  #     assert exam.area == "some area"
  #     assert exam.edition == "some edition"
  #     assert exam.exam_questions_count == 42
  #     assert exam.name == "some name"
  #     assert exam.speciality == "some speciality"
  #     assert exam.year == "some year"
  #   end
  #
  #   test "create_exam/1 with invalid data returns error changeset" do
  #     assert {:error, %Ecto.Changeset{}} = Exams.create_exam(@invalid_attrs)
  #   end
  #
  #   test "update_exam/2 with valid data updates the exam" do
  #     exam = exam_fixture()
  #     assert {:ok, %Exam{} = exam} = Exams.update_exam(exam, @update_attrs)
  #     assert exam.area == "some updated area"
  #     assert exam.edition == "some updated edition"
  #     assert exam.exam_questions_count == 43
  #     assert exam.name == "some updated name"
  #     assert exam.speciality == "some updated speciality"
  #     assert exam.year == "some updated year"
  #   end
  #
  #   test "update_exam/2 with invalid data returns error changeset" do
  #     exam = exam_fixture()
  #     assert {:error, %Ecto.Changeset{}} = Exams.update_exam(exam, @invalid_attrs)
  #     assert exam == Exams.get_exam!(exam.id)
  #   end
  #
  #   test "delete_exam/1 deletes the exam" do
  #     exam = exam_fixture()
  #     assert {:ok, %Exam{}} = Exams.delete_exam(exam)
  #     assert_raise Ecto.NoResultsError, fn -> Exams.get_exam!(exam.id) end
  #   end
  #
  #   test "change_exam/1 returns a exam changeset" do
  #     exam = exam_fixture()
  #     assert %Ecto.Changeset{} = Exams.change_exam(exam)
  #   end
  # end
end
