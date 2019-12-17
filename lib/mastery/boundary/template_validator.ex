defmodule Mastery.Boundary.TemplateValidator do
  alias Mastery.Boundary.Validator

  @atom "must be an atom"
  @arrity "must be an arrity 2 function"
  @binary "must be a binary"
  @blank "can't be blank"
  @empty "can't be empty"
  @generator "must be a string to list or function pair"
  @keyword_list "A keyword list of fields is required"
  @map "must be a map"
  @string "must be a string"

  def errors(fields) when is_list(fields) do
    fields = Map.new(fields)

    []
    |> Validator.require(fields, :name, &validate_name/1)
    |> Validator.require(fields, :category, &validate_name/1)
    |> Validator.optional(fields, :instructions, &validate_instrucions/1)
    |> Validator.require(fields, :raw, &validate_raw/1)
    |> Validator.require(fields, :generators, &validate_generators/1)
    |> Validator.require(fields, :checker, &validate_checker/1)
  end

  def errors(_fields), do: [{nil, @keyword_list}]

  def validate_name(name) when is_atom(name), do: :ok

  def validate_name(_name), do: {:error, @atom}

  def validate_instructions(inst) when is_binary(inst), do: :ok

  def validate_instructions(_inst), do: {:error, @binary}

  def validate_raw(raw) when is_binary(raw) do
    check(String.match?(raw, ~r{\S}), {:error, @blank})
  end

  def validate_raw(_raw), do: {:error, @string}

  def validate_generators(generators) when is_map(generators) do
    generators
    |> Enum.map(&validate_generator/1)
    |> Enum.reject(&(&1 == :ok))
    |> case do
      [] -> :ok
      errors -> {errors: errors}
    end
  end

  def validate_generators(_gen), do: {:error, @map}

  def validate_generator({name, generator}) when is_atom(name) and is_list(generator) do
    check(generator != [], {:error, @empty})
  end

  def validate_generator(_gen), do: {:error, @generator}

  def validate_checker(checker) when is_function(checker, 2), do: :ok

  def validate_checker(_checker), do: {:error, @arrity}
end
