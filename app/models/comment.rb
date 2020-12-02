class Comment < ActiveRecord::Base
  include ActsAsCommentable::Comment
  acts_as_mentioner
  acts_as_taggable_on :mention
  belongs_to :commentable, :polymorphic => true

  default_scope -> { order('created_at DESC') }

  # NOTE: install the acts_as_votable plugin if you
  # want user to vote on the quality of comments.
  #acts_as_voteable

  # NOTE: Comments belong to a user
  belongs_to :user

  acts_as_commentable

  acts_as_mentioner
end
