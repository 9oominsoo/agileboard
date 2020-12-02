class UserMailer < ApplicationMailer
  default :from => 'tjdals1771@gmail.com'
  
  def send_post_created_email(post)
    @post = post
    @post.participant_list.each do |user|
      unless user == ""
        mail(to: User.find_by(id: user).email, subject: 'Post created successfully!')
      end
    end
  end

  def send_status_changed_email(function)
    @function = function
    @function.user_list.each do |user|
      if (u = User.find_by(id: user.to_i)).present?
        mail(to: "rnalstn0507@gmail.com", subject: @function.title + "의 상태 변경 알림")
      end
    end
  end
  
  def send_comment_mentioned_email(comment)
    @comment = comment
    @comment_post = Post.find(comment.commentable_id)
    @comment.mention_list.each do |user|
      if (u = User.find_by(id: user.to_i)).present?
        mail(to: "submailid@ajou.ac.kr", subject: @comment_post.title + "의 댓글에서"+ u.name+ "님을 언급하셨습니다.")
      end
    end
  end

end
