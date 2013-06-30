module SiteHelper
  def render_nav_class(a, c='site')
    @cname = controller.controller_name 
    @aname = controller.action_name 
    (c == @cname && a == @aname) ? "current" : ""
  end
  
  def render_sub_menu(a, c='site')
    @cname = controller.controller_name 
    @aname = controller.action_name
    ret = ""    
    case c
    when 'site'
      case a
      when 'about'
        ret += <<-EOL
          <ol class="sub-menu-list-dropdown">
            <li>#{link_to "FAQ", faq_path, :class=>render_nav_class("faq")}</li>
            <li>#{link_to "Watch Our Video", demo_path, :class=>render_nav_class("demo")}</li>
      		</ol>
        EOL
      end
    when 'sites'
      case a
      when 'new'
        if ["submit_links_program", "agreement", "new", "hall_of_fame"].include? @aname
          ret += <<-EOL
            <ol class="sub-menu-list-dropdown">
              <li>#{link_to "ubExactor ubExpert Submit Links Program", submit_links_program_path, :class=>render_nav_class("submit_links_program")}</li>
              <li>#{link_to "Submit Links Agreement", agreement_path, :class=>render_nav_class("agreement")}</li>
              <li>#{link_to "Submit Links Registration", signup_path, :class=>render_nav_class("new", "users")}</li>
              <li>#{link_to "ubExactor ubExpert Hall of Fame", hall_of_fame_path, :class=>render_nav_class("hall_of_fame")}</li>
        		</ol>
          EOL
        end
      end
    end
    ret
  end
  
  def render_location_link_label(site)
    loc = site.location
    loc << "(part of the Greater #{site.metro_service_area.name} MSA)" if !site.state.nil? && !site.metro_service_area.nil?
    (loc.blank?) ? "Online" : loc
  end
  
  def render_hall_of_fame_image(user)
    ret = ""
    if user.is_ubexactor?
      ret += image_tag("ubExactor_Icon_thumb.jpg")
    elsif user.is_ubexpert?
      ret += image_tag("ubExpert_Icon_thumb.jpg")
    end
    ret
  end
end
