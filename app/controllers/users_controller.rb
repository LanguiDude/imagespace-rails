class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update]
  before_action :correct_user,   only: [:edit, :update]
  
  def index
    @users = User.all
  end
  
  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
        log_in @user
        redirect_to @user
      # Handle a successful save.
    else
      render 'new'
    end
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
  
  def edit
    @user = User.find(params[:id])
  end
  
    private

    def user_params
      params.require(:user).permit(:email, :password,
                                   :password_confirmation)
    end


  # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
      store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end


    # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
end