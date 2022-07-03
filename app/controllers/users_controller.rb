class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :correct_user, only: [:edit, :update　]
  before_action :admin_user, only: [:destroy, :edit_basic_info, :update_basic_info, :in_attendance] 
  before_action :set_one_month, only: :show
  before_action :admin_or_correct, only: :show

  def basic_info
  end


  
  def bases
  end

  def index
    @users = User.paginate(page: params[:page], per_page: 20)
    # @users = @users.where('name LIKE?', "%#{params[:search]}%") if params[:search].present?
  end

  def show
    @users = User.all
    @worked_sum = @attendances.where.not(started_at: nil).count
    @r_count = Report.where(r_request: @user.name, r_approval: "申請中").count
    @a_count = Attendance.where(c_request: @user.name, c_approval: "申請中").count
    @o_count = Attendance.where(o_request: @user.name, o_approval: "申請中").count
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = '新規作成に成功しました。'
      redirect_to @user
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "ユーザー情報を更新しました。"
      redirect_to @user
    else
      render :edit      
    end
  end

  def destroy
    @user.destroy
    flash[:success] = "#{@user.name}のデータを削除しました。"
    redirect_to users_url
  end


  def update_basic_info
    if @user.update_attributes(basic_info_params)
      flash[:success] = "#{@user.name}の基本情報を更新しました。"
    else
      flash[:danger] = "#{@user.name}の更新は失敗しました。<br>" + @user.errors.full_messages.join("<br>")
    end
    redirect_to users_url
  end
  
  def admin_or_correct
      @user = User.find(params[:user_id]) if @user.blank?
    unless current_user?(@user) || current_user.admin?
      flash[:danger] = "アクセス出来ません。"
      redirect_to(root_url)
    end
  end
  
  def in_attendance
    @users = User.all
  end
  

  private

    def user_params
      params.require(:user).permit(:name, :email, :department, :password, :password_confirmation)
    end
    
    def basic_info_params
      params.require(:user).permit(:department, :basic_time, :work_time)
    end

    # beforeフィルター

    # paramsハッシュからユーザーを取得します。
    def set_user
      @user = User.find(params[:id])
    end

    # ログイン済みのユーザーか確認します。
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "ログインしてください。"
        redirect_to login_url
      end
    end

    # アクセスしたユーザーが現在ログインしているユーザーか確認します。
    def correct_user
      redirect_to(root_url) unless current_user?(@user)
    end

    # システム管理権限所有かどうか判定します。
    def admin_user
      redirect_to root_url unless current_user.admin?
    end
    
    def notice_overtime
      @notice_user = User.where(id: Attendance.where(o_request: @user.name, o_approval: "申請中").select(:user_id))
    end
    
  
end