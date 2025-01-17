class CommentsController < ApplicationController
  def new
    @path = params[:path]
    @commentable = find_commentable
    @comment = @commentable.comments.build
  end

  def create
    @commentable = find_commentable
    @comment = @commentable.comments.build(comment_params)
    @path = path_params[:path]

    if @comment.save
      if @path == profile_url(current_user.profile.id)
        redirect_to profile_path(current_user.profile.id, anchor: "#{@commentable.class}-#{@commentable.id}")
      elsif @path == root_url
        redirect_to root_path(anchor: "#{@commentable.class}-#{@commentable.id}")
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @path = params[:path]
    @commentable = find_commentable
    @comment = Comment.find(params[:id])
  end

  def update
    @commentable = find_commentable
    @comment = Comment.find(params[:id])
    @path = path_params[:path]

    if @comment.update(comment_params)
      if @path == profile_url(current_user.profile.id)
        redirect_to profile_url(current_user.profile.id, anchor: "#{@commentable.class}-#{@commentable.id}")
      elsif @path == root_url
        redirect_to root_path(anchor: "#{@commentable.class}-#{@commentable.id}")
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    @path = params[:path]
    @commentable = @comment.commentable
    redirect_to "#{@path}##{@commentable.class}-#{@commentable.id}", status: :see_other
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :commenter_id)
  end

  def path_params
    params.require(:comment).permit(:path)
  end

  def find_commentable
    params.each do | id_name, id_value |
      if id_name == "image_post_id"
       return ImagePost.find(id_value)

      elsif id_name == "post_id"
        return Post.find(id_value)
      end
    end
  end
end
