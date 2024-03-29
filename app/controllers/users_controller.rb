class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]
  before_action :require_logout, only: %i[new create]
  before_action :require_admin, only: %i[edit update destroy]
  skip_before_action :require_login, only: %i[new create]

  # GET /users
  # GET /users.json
  def index
    @users = User.all.order(admin: :desc)
  end

  # GET /users/1
  # GET /users/1.json
  def show; end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit; end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(create_user_params)

    respond_to do |format|
      if @user.save
        session[:user_id] = @user.id
        format.html { redirect_to @user, notice: 'Successful registration' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(update_user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Don't let the admin parameter to be set in the create function
  def create_user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  # Only allow a list of trusted parameters through.
  def update_user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :admin)
  end
end
