module TimelineHelper
  def get_new_timeline_path
    if nested?
      new_timeline_timeline_path(owner)
    else
      new_timeline_path
    end
  end

  def get_show_child_path(parent, child)
    if child.class == Timeline
      timeline_path(child)
    else
      timeline_event_path(parent, child)
    end
  end
  
  def nested?
    owner.class == Timeline
  end

  # The return value of this method depends on whether timelines are being accessed as a nested resource
  #   When accessing the top level resource, this returns the current user
  #   When accessing a nested timeline, this returns the parent timeline specified in the URL
  #     Ex. the timeline with ID 1 would be returned for /timelines/1/timelines/4
  def owner
    parent_id = params[:timeline_id]
    parent_id.nil? ? current_user : current_user.timelines.find(parent_id)
  end
end
