class Attendance < ApplicationRecord

  after_create :new_guest_email_send

  def new_guest_email_send
    AttendanceMailer.new_guest_email(self).deliver_now
  end

  validates :stripe_customer_id, uniqueness: true

  belongs_to :guest, class_name: "User"
  belongs_to :event, optional: true

end
 