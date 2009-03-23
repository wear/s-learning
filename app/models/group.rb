class Group < ActiveRecord::Base 
  acts_as_taggable
  has_one :asset, :as => 'attachable' 
  has_one :wiki, :dependent => :destroy
  validates_presence_of :title, :on => :create

  has_many :memberships
  has_many :members, :through => :memberships, :source => :user, :conditions => 'accepted_at IS NOT NULL'
  has_many :pending_members, :through => :memberships, :source => :user,:conditions => 'accepted_at IS NULL'
  has_many :mods, :through => :memberships, :source => :user, :conditions => ['admin_role = ?', true]
  after_save :create_initial_wiki 
  
  def membership(user)
    Membership.find(:first, :conditions => ['group_id = ? AND user_id = ?', self.id, user.id])
  end
  
  def accept_member(user)
    self.membership(user).update_attribute(:accepted_at, Time.now)
  end
  
  def pending_and_accepted_members
    self.pending_members + self.members
  end
  
  def kick(user)
    self.membership(user).destroy if user.is_member_of?(self)
  end
  
  def set_mod(user)
    self.membership(user).update_attribute(:admin_role, true)
  end
  
  def mods_online
    self.mods.find(:all, :conditions => ['users.updated_at > ?', 50.seconds.ago])
  end
  
  def members_online
    self.members.find(:all, :conditions => ['users.updated_at > ?', 70.seconds.ago])
  end
  
  def members_offline
    self.members - self.members_online
  end
  
  def has_member?(user)
    self.members.include?(user)
  end
  
  def icon_exists?
    return false unless asset
    File.file? "public/#{asset.public_filename}"
  end
  
  def icon_data=(data)
    return if data.blank? 
    if asset
      asset.update_attributes :uploaded_data => data
    else
      self.asset = Asset.create :uploaded_data => data
    end
  end
  
  def create_initial_wiki
    if self.wiki.nil?
      Wiki.create(:group => self, :start_page => 'Wiki')
    end
  end
end
