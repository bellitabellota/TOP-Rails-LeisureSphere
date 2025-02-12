class PostsController < ApplicationController
  def new
    @post = current_user.posts.build()
  end

  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])

    if @post.update(post_params)
      redirect_to profile_path(current_user.profile.id)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to profile_path(current_user.profile.id), status: :see_other
  end

  private

  def post_params
    params.require(:post).permit(:body)
  end
end
