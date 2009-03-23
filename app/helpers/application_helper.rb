require 'coderay'
require 'coderay/helpers/file_type'
require 'forwardable'
require 'cgi'

module ApplicationHelper 
  include WikiFormatting::Macros::Definitions
#  include GravatarHelper::PublicMethods

  extend Forwardable
  def_delegators :wiki_helper, :wikitoolbar_for, :heads_for_wiki_formatter
  
	
	def group_icon_for(group)
    if group.icon_exists?
      image_tag group.asset.public_filename(:thumb)
    else
      image_tag('/plugin_assets/community_engine/images/icon_missing_thumb.gif')
    end
  end 
  
  def html_title(*args)
    if args.empty?
      title = []
      title << @project.name if @project
      title += @html_title if @html_title
      title << AAppConfig.community_name
      title.compact.join(' - ')
    else
      @html_title ||= []
      @html_title += args
    end
  end
  
  def wiki_helper
    helper = WikiFormatting.helper_for(AppConfig.text_formatting)
    extend helper
    return self
  end
         

end
