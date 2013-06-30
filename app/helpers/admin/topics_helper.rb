module Admin::TopicsHelper
  def render_topic_hierarchy(topic, linkable=false)
    output = topic.name
    unless topic.parent.nil?
      if linkable
        output = link_to(topic.parent.name, admin_topic_path(topic.parent)) + " > " + output
      else
        output = topic.parent.name + " > " + output
      end
    end
    unless topic.parent.nil? || topic.parent.parent.nil?
      if linkable
        output = link_to(topic.parent.parent.name, admin_topic_path(topic.parent.parent)) + " > " + output
      else
        output = topic.parent.parent.name + " > " + output
      end
    end
    output
  end
end
