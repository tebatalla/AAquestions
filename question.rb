class Question < ActiveRecordLite
  attr_accessor :id, :title, :body, :author_id

  def initialize(params = {})
    self.id = params["id"]
    self.title = params["title"]
    self.body = params["body"]
    self.author_id = params["author_id"]
  end

  def author
    User.find_by(id: author_id)
  end

  def replies
    Reply.find_by(question_id: id)
  end

  def followers
    QuestionFollows.followers_for_question_id(id)
  end

  def self.most_followed(n)
    QuestionFollows.most_followed_questions(n)
  end

  def likers
    QuestionLikes.likers_for_question_id(id)
  end

  def num_likes
    QuestionLikes.num_likes_for_question_id(id)
  end

  def self.most_liked(n)
    QuestionLikes.most_liked_questions(n)
  end
end
