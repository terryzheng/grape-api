module ApplicationHelper
  def get_ask
    if !$redis_asks.exists(params[:id])
      error!("Ask not found.", 200)
    end
  end
  
  def get_topic
    @topic_id = $redis_topics.hget(params[:name],:id)
    if @topic_id.blank?
      error!("Topic not found.", 200)
    end
  end
  
  def get_user(fields="")
    @user=User.nondeleted.only(fields).where(:slug=>params[:id]).first
    if @user.blank?
      error!("User not found.", 200)
    end
  end
  
  def api_super_client?
    request.ip.starts_with?('192.168') or request.ip.starts_with?('172.30') or request.ip=='127.0.0.1'
  end

  def api_current_user_slug
    $redis_users.hget(@current_client.first.user_id,:slug)
  end

  def render_this!
    {"size"=>@ret.to_a.count,"result"=>@ret}
  end
  
  def render_ask!
    {"size"=>@ret.to_a.count,"result"=>@ret.map{|x|user = $redis_users.hgetall(x.user_id);{id:x.id,title:x.title,user:[user["slug"],user["name"]],answers_count:x.answers_count}}}
  end
  
  def pagination_get_ready
    @page = (params[:page].to_i>0)? params[:page].to_i : 1
    @per_page = (params[:per_page].to_i>0)? ((params[:per_page].to_i>100)? 100 : params[:per_page].to_i) : 20
  end
end