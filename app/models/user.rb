class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def isadmin?
    isadmin = true
    admin = Admin.find_by_email(self.email)
    if admin.nil?
      isadmin = false
    end
    return isadmin
  end

  def addadmin
    admin = Admin.find_by_email(self.email)
    if admin.nil?
      Admin.create(email: email)
    end  
  end

  def lessadmin
    unless self.email == "jimenezmaury@gmail.com"
      admin = Admin.find_by_email(self.email)
      unless admin.nil?
        admin.destroy
      end
    end  
  end

end
