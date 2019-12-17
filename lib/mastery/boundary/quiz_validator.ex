defmodule Mastery.Boundary.QuizValidator do
  alias Mastery.Boundary.Validator

  @blank "can't be blank"
  @integer "must be an integer"
  @required "A map of fields is required"
  @string "must be string"
  @zero "must be greater than zero"

  def errors(fields) when is_map(fields) do
    []
    |> Validator.require(fields, :title, &validate_title/1)
    |> Validator.optional(fields, :mastery, &validate_mastery/1)
  end

  def errors(_fields), do: [{nil, @required}]

  def validate_title(title) when is_binary(title) do
    Validator.check(String.match?(title, ~r{\S}), {:error, @blank})
  end

  def validate_title(_title), do: {:error, @string}

  def validate_mastery(mastery) when is_integer(mastery) do
    Validator.check(mastery >= 1, {:error, @zero})
  end

  def validate_mastery(_mastery), do: {:error, @integer}
end
