defmodule Mastery.Core.Response do
  defstruct ~w[quiz_title template_name to email answer correct timestamp]a

  # TODO
  # Cons - I don't like this, Response knows about the inner workings of quiz and question 
  #        in order to extract it's own information from these other structs
  #        it's not like quiz is an Enum or implementing a certain behaviour
  #        it is it's own seperate data structure. This could be done in a module
  #        that has knowledge of all structs. In testing I need to pass in enough
  #        of a data structure to fake out a quiz with a question and a template.
  #        I have to build the world to test with this constructor function.
  #        I would rather pass simple data instead even though it may be longer
  #        in code. 
  # %Response{
  #  quiz_title: "test1",
  #  template_name: "test_template1",
  #  to: "test_question1",
  #  email: "nope@gmail.nop",
  #  answer: "nope",
  #  correct: false
  # }
  # Pros - I think it is interesting to use the template checker function here.
  def new(quiz, email, answer) do
    question = quiz.current_question
    template = question.template

    %__MODULE__{
      quiz_title: quiz.title,
      template_name: template.name,
      to: question.asked,
      email: email,
      answer: answer,
      correct: template.checker.(question.substitutions, answer),
      timestamp: DateTime.utc_now()
    }
  end
end
