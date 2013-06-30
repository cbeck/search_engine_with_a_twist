# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def home_uri
    key = session[:history_key]
    (key.nil? || request.host == MY_HOST) ? "http://#{MY_HOST}" : "http://#{MY_HOST}?u=#{key}"
  end

  def disable_enter_key
    { :onKeyPress=>'return disableEnterKey(event)' }
  end
  
  def add_item_link(tag_id, partial, object, label=nil)
    link_to_function "add #{label || partial}" do |page|
			page.insert_html :bottom, tag_id, :partial => partial, :object => object
		end
  end
  
  def remove_item(name="item", distance=0)
    link_to_function(image_tag('bin.png', :title => "remove #{name}"), "up(#{distance}).remove()")
  end
  
  def remove_item_link(name, object, action)
    if object.new_record?
      link_to_function(image_tag('bin.png', :title => "remove #{name}"), "up(0).remove()")
    else
      link_to_remote(image_tag('bin.png', :title => "remove #{name}"), 
				:url => { :action => action, :id => object },
				:confirm => "Delete this #{name}: #{object.to_s}?",
				:success => "up(0).remove()")
		end
  end
  
  def existing_field_id(form, object)
  	unless object.new_record?
  		form.hidden_field(:id, :index => nil)
  	end
  end
  
  def menu_class(cname, aname=nil)
    (controller.controller_name == cname  && (aname.nil? || controller.action_name == aname)) ? 'current' : ''
  end
  
  def google_analytics
    urchin = <<-EOS
      <script src="http://www.google-analytics.com/urchin.js" type="text/javascript">
      </script>
      <script type="text/javascript">
      _uacct = "UA-1147482-6";
      urchinTracker();
      </script>
    EOS
    urchin if ENV['RAILS_ENV'] == 'production'
  end
  
  def one_column(page_width=nil)
    @one_column = true
    @page_width = page_width unless page_width.nil?
  end
  
  def sidebar_styles
    attr = ""
    attr << ' class="no_side_bar"' if @one_column
    attr << " style='width: #{@page_width}px; margin: 0 auto;'" if @page_width
    attr
  end
  
  # A helper to show flash messages as an ajax messenger be it as a notice or error (if warning). Options include the keys to test
  # the id of the messages client, and whether to textilize the data.
  def show_ajax_flash_messages(options={}, page=nil)
     options = { :keys => [:warning, :notice, :message],
                  :id => 'messages',
                  :textilize => false,
                  :wrap_js => true}.merge(options)
      out = []
      message = nil
      options[:keys].each do |key|
        next unless flash[key]
        [flash[key]].flatten.compact.each do |msg|
          text = (options[:textilize] ? textilize(msg) : msg)
          message = text
        end
        type = "notice"
        type = "error" if key == :warning
        if !message.nil?
          if page.nil?
            out << "<script type=\"text/javascript\"> " if options[:wrap_js]
            out << "Messenger."+type+"(\"#{message.strip.gsub('"','\"')}\");"
            out << "</script>" if options[:wrap_js]
          else
            page << "Messenger."+type+"(\"#{message.strip.gsub('"','\"')}\");"
          end
        end
        flash.discard(key)
      end
      if page.nil?
        return nil if out.empty? 
        return out
      end
  end
  
  def nested_error_messages_for(object)
    object = instance_variable_get("@#{object}") if ([Symbol, String].member? object.class)
      unless object.nil? || object.errors.count.zero?      
        error_messages = object.errors.to_a.uniq.map do |key, value|
          if key == "base"
            content_tag(:li, value)
          else
            object2 = object.send(key)
            if object2.is_a?(Array) 
              object2.collect {|obj| content_tag(:li, nested_error_messages_for(obj)) }
            elsif object2.is_a?(ActiveRecord::Base)
              content_tag(:li, nested_error_messages_for(object2))
            elsif value.match(/^\^/)
              content_tag(:li, value[1..value.length])
            else
              content_tag(:li, "#{key.underscore.split('_').join(' ').humanize} #{value}")
            end
          end
        end
        content_tag(:div, 
          content_tag(:div, "#{object.class.to_s.underscore.humanize} has errors", :class => 'error_field') +
          content_tag(:ul, error_messages),
          :class => 'error_block')
      else
        ''
      end
  end
end
