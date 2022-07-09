class ReportsController < ApplicationController
  before_action :set_user, only: [:notice_report]
  
  def new
  end
  
  def notice_report
    @notice_user = User.where(id: Report.where(r_request: @user.name, r_approval: "申請中").select(:user_id))
    @report_lists = Report.where(r_request: @user.name, r_approval: "申請中")
  end
  
  private
  
  # 通知のあった所属長承認申請の承認を扱います。
  def notice_report_params
    params.require(:user).permit(reports: [:r_month, :r_approval, :change, :user_id])[:reports]
  end
  
end
