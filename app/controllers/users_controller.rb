class UsersController < ApplicationController

  before_action :set_user, only: [:show, :edit, :update, :destroy]


  def index
    @users = User.all
  end

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(allowed_params)
    if @user.save
      if params[:user][:avatar].present?
        render :crop
      else
        redirect_to @user, notice: "Successfully created user."
      end
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(allowed_params)
      if params[:user][:avatar].present?
        render :crop
      else
        redirect_to @user, notice: "Successfully updated user."
      end
    else
      render :new
    end
  end

  def destroy
    @user.avatar.purge
    @user.destroy
    redirect_to users_url, notice: "Successfully destroyed user."
  end

  private
  def set_user
    @user = User.find(params[:id])
  end

  def allowed_params
    params.require(:user).permit!
  end
end
