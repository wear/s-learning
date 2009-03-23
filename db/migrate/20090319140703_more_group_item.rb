class MoreGroupItem < ActiveRecord::Migration
  def self.up
    add_column :groups, :domain, :string
    add_column :groups, :description, :text
    add_column :groups, :access, :integer
    add_column :groups, :member_count, :integer
    add_column :groups, :logo, :string
    add_column :groups, :appearance, :integer
    add_column :memberships, :pending_message, :string
    add_column :posts, :group_id, :integer
  end

  def self.down
    remove_column :memberships, :pending_message
    remove_column :groups, :appearance
    remove_column :groups, :logo
    remove_column :groups, :member_count
    remove_column :groups, :access
    remove_column :groups, :domain
    remove_column :groups, :description
    remove_column :posts, :group_id
  end
end
