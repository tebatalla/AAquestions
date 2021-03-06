class User < ActiveRecordLite
  attr_accessor :id, :fname, :lname

  def initialize(params = {})
    self.id = params["id"]
    self.fname = params["fname"]
    self.lname = params["lname"]
  end

  def authored_questions
    Question.find_by(author_id: id)
  end

  def authored_replies
    Reply.find_by(user_id: id)
  end

  def followed_questions
    QuestionFollows.followed_questions_for_user_id(id)
  end

  def liked_questions
    QuestionLikes.liked_questions_for_user_id(id)
  end

  def average_karma
    QuestionsDatabase.instance.get_first_value(<<-SQL, user_id: id)
      SELECT
        CAST(COUNT(question_likes.id) AS FLOAT) / COUNT(DISTINCT(questions.id)) AS karma
      FROM
        questions
      LEFT JOIN
        question_likes ON questions.id = question_likes.question_id
      WHERE
        questions.author_id = :user_id
      SQL
  end
end
