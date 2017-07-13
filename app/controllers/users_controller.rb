class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :show, :edit, :update, :following]

  def show
    @user = User.find(params[:id])
    @artists = @user.following.paginate(page: params[:page])
  end

  def index
    @users=User.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def following
    @user = User.find(params[:id])
    @artists = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  private
    def user_params
      params.require(:user).permit(:name_first, :name_last, :email, :password, :password_confirmation, :profile_pic)
    end

    def set_user
      @user = User.find(params[:id])
    end

end
