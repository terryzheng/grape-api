class TopicController < Grape::API  
  before do
    @current_client = Client.where(:uri=>params[:client_id])
    if @current_client.count==0
      error!("#{request.ip} Unauthorized access.", 401)
    end
  end
  
  get '/' do
    pagination_get_ready
    if !params[:newbie].blank?
      @topics = TopicCache.only(TopicCache::FIELDS)
    else
      @topics = Topic.only(Topic::FIELDS).nondeleted
      @topics = @topics.where(:name=>/#{params[:q]}/) if params[:q]
      @topics = @topics.where(:tags => params[:tag]) if params[:tag]
      @topics = @topics.desc(params[:sort]) if params[:sort]
      @topics = @topics.desc("created_at")
    end
    @ret = @topics.skip((@page-1)*@per_page).limit(@per_page)
    render_this!
  end
  
  get '/:name/suggest_topics' do
    get_topic
    @related_topics = TopicSuggestTopic.only(:topics).where(:topic_id=>Moped::BSON::ObjectId(@topic_id)).first
    if !@related_topics.blank?
      @related_topics.topics
    else
      []
    end
  end
  
  get '/:name/suggest_experts' do
    get_topic
    @related_topics = TopicSuggestExpert.only(:expert_ids).where(:topic_id=>Moped::BSON::ObjectId(@topic_id)).first
    if !@related_topics.blank?
      @related_topics.expert_ids
    else
      []
    end
  end
end
