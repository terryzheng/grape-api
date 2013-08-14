class AskController < Grape::API  
  before do
    @current_client = Client.where(:uri=>params[:client_id])
    if @current_client.count==0
      error!("#{request.ip} Unauthorized access.", 401)
    end
  end
  
  get '/' do
    pagination_get_ready
    if !params[:newbie].blank?
      ask_map={}
      AskCache.only(:ask_id).skip((@page-1)*20).limit(20).each_with_index{|a,i|ask_map[a.ask_id]=i}
      @asks = Ask.nondeleted.normal.only(Ask::FIELDS).where(:_id.in=>ask_map.keys)
      @ret = @asks.sort{|a,b|ask_map[a._id]<=>ask_map[b._id]}
    else
      @asks = Ask.nondeleted.normal.only(Ask::FIELDS)
      @asks = @asks.unanswered if !params[:zero_answers].blank?
      @asks = @asks.where(:topics=>params[:topic_name]) if !params[:topic_name].blank?
      @asks = @asks.where(:no_display_at_index.ne=>true).desc("created_at")
      @ret = @asks.skip((@page-1)*@per_page).limit(@per_page)
    end
    render_ask!
  end

  get ':id' do
    arr=params[:id].split(",").uniq
    if arr.count>1
      @asks = Ask.nondeleted.normal.where(:_id.in=>arr).to_a
      if @asks.count>0
        @asks
      else
        error!("resource not found.", 200)
      end
    elsif arr.count>0
      @ask = Ask.nondeleted.normal.where(:_id=>arr[0]).first
      if @ask.blank?
        error!("resource not found.", 200)
      else
        @ask
      end
    end
  end

  get '/:id/sugg' do
    get_ask
    @related_asks = AskSuggestAsk.where(:ask_id=>Moped::BSON::ObjectId(params[:id])).first
    if !@related_asks.blank?
      @ret = @related_asks.ask_ids
    else
      @ret = []
    end
    render_this!
  end

  get '/:id/logs' do
    get_ask
    pagination_get_ready
    @logs = Log.only(Log::FIELDS).where(:target_id=>Moped::BSON::ObjectId(params[:id])).desc(:created_at)
    @ret = @logs.skip((@page-1)*@per_page).limit(@per_page)
    render_this!
  end
end
