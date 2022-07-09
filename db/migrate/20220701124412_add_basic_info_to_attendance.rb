class AddBasicInfoToAttendance < ActiveRecord::Migration[5.1]
  def change
    #勤怠変更申請
    add_column :attendances, :c_approval, :string
    add_column :attendances, :c_request, :string
    
    #残業申請
    add_column :attendances, :o_approval, :string
    add_column :attendances, :o_request, :string
    add_column :attendances, :end_time, :datetime
    add_column :attendances, :overtime, :float
    add_column :attendances, :business_process, :string
  end
end
