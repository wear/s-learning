class GroupsController < BaseController
  before_filter :login_required, :only => [:new, :edit, :create, :destroy, :join, :manage]
 # before_filter :find_user, :only => [:new, :edit, :index, :show, :update_views, :manage]
  
  def index
  end      
  
  def show
    @group = Group.find params[:id] 
    get_recent_footer_content
  end 
  
  def new
    @group = Group.new
  end
  
  def edit
    @group = Group.find params[:id]
    respond_to do |wants|
      if current_user.becomes(LearnUser).is_mod_of?(@group)
        wants.html {  } 
      else 
        flash[:error] = 'you don have permission to do that!'
        wants.html {render :action => "show"}
      end
    end
  end
  
  def update
     @group = Group.find params[:id]
     respond_to do |wants|
       if current_user.becomes(LearnUser).is_mod_of?(@group)
         flash[:notice] = 'group was successfully updated!'
         @group.update_attributes(params[:group])
         wants.html { redirect_to @group }
       else                                          
         wants.html { render :action => "edit" }
         flash[:error] = 'you don have permission to do that!'
         wants.html {render :action => "show"}
       end                                                    
     end   
  end
  
  def create
    @group = Group.new params[:group]
    respond_to do |wants|
      if @group.save
        current_user.becomes(LearnUser).become_admin_of(@group)
        flash[:notice] = 'group was successfully created!'
        wants.html { redirect_to root_path }   
      else      
        wants.html { render :action => "new" }
      end
    end
  end
  
  def destroy
    @group = Group.find(params[:id])
    respond_to do |wants|
    if @group.created_by == current_user.id
      @group.destroy
        flash[:notice] = 'group was successfully deleted!'                      
        wants.html { redirect_to root_path }
    else
        flash[:error] = 'you don have permission to do that!'    
        wants.html { redirect_to root_path }
      end
    end
  end
  
  def join
    @group = Group.find params[:id]
    unless current_user.becomes(LearnUser).membership(@group) 
      current_user.becomes(LearnUser).become_member_of(@group)
      flash[:notice] = :group_request_send.l
    else
      flash[:error] = :already_group_member.l
    end
    respond_to do |wants|
      wants.html { redirect_to @group }
    end
  end
  
  def activity
    @group = Group.find params[:id]
    get_recent_footer_content 
  end 
  
  def members
    @group = Group.find params[:id]
  end       
  
  def accept
    @group = Group.find params[:group_id]
    @member = User.find params[:member_id]
    if @group.accept_member(@member) 
      flash[:notice] = :member_accepted.l
    else
      flash[:error] = :member_accept_error.l
    end
    respond_to do |wants|
      wants.html { redirect_to @group }
    end
  end 
  
  protected
  
  def get_recent_footer_content
    @recent_activity = User.recent_activity(:size => 15, :current => 1)
  end
end
