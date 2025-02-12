class ProfilesController < ApplicationController
  def show
    @profile = Profile.includes(:user).find(params[:id])
    @text_posts = @profile.user.posts.includes(:likers, { comments: { commenter: :profile } })
    @image_posts = @profile.user.image_posts.includes(:likers, { comments: { commenter: :profile } })
    @feed_items = (@text_posts + @image_posts).sort_by { |item| item.created_at }.reverse
  end

  def edit
    @profile = Profile.find(params[:id])
  end

  def update
    @profile = Profile.find(params[:id])
    @user = User.find(current_user.id)
    if @profile.update(profile_params) && @user.update(user_name_param)
      redirect_to profile_path(@profile)
    else
      user = User.find_by(user_name_param)
      if user != current_user && user
        flash[:alert] = "The username must be unique."
      end

      @profile.profile_picture = nil
      render :edit, status: :unprocessable_entity
    end
  end

  def delete_image
    image = ActiveStorage::Attachment.find(params[:image_id])

    image.purge
    redirect_back(fallback_location: request.referrer)
  end

  private

  def profile_params
    params.require(:profile).permit(:birthday, :location, :interests, :avatar_url, :profile_picture)
  end

  def user_name_param
    params.require(:profile).require(:user).permit(:name)
  end
end
