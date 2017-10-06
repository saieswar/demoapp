class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
 # has_one_time_password
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_one :seller
	 has_one :agent
	 belongs_to :role
	 #after_create :send_confirmation_instruction
     #def send_confirmation_instruction
      # UserMailer.send_confirmation_instruction(self).deliver_later unless provider.present? || csr_agent? || csr_home_owner?
     #end
end
