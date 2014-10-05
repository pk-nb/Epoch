module TimelineHelper
  def get_new_timeline_path
    if nested?
      new_timeline_timeline_path(owner)
    else
      new_timeline_path
    end
  end
  
  def nested?
    owner.class == Timeline
  end
  
  def owner
    parent_id = params[:timeline_id]
    parent_id.nil? ? current_user : current_user.timelines.find(parent_id)
  end
end
