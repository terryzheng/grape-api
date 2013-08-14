class UserController < Grape::API 
  before do
    @current_client = Client.where(:uri=>params[:client_id])
    if @current_client.count==0
      error!("#{request.ip} Unauthorized access.", 401)
    end
  end
  
  get '/:id' do
    slug=params[:id]
    if !api_super_client? and api_current_user_slug!=slug
      error!("Unauthorized access.", 401)
    end
  
    u=User.nondeleted.only(User::FIELDS).where(:slug=>slug).first
    u ||= User.nondeleted.only(User::FIELDS).where(:email=>params[:email]).first if !params[:email].blank?
    u ||= User.nondeleted.only(User::FIELDS).where(:_id=>slug).first
    u
  end

  get '/' do
    pagination_get_ready
    if params[:experts].blank? and params[:elites].blank? and params[:current_user].blank?
      error!("it is not allowed to get all users.", 401)
    end
  
    if !params[:current_user].blank?
      if api_current_user_slug.blank?
        error!("Unauthorized access.", 401)
      end
      return User.nondeleted.only(User::FIELDS).where(:slug=>api_current_user_slug).first
    elsif !params[:experts].blank?
      @users = User.nondeleted.only(User::FIELDS)
      @users = @users.where(:expert_type=>User::EXPERT_USER)
    elsif !params[:elites].blank?
      @users = User.nondeleted.only(User::FIELDS)
      @users = @users.where(:expert_type=>User::ELITE_USER)
    end
    @ret = @users.skip((@page-1)*@per_page).limit(@per_page)
    render_this!
  end

  get '/:id/asked' do
    get_user
    pagination_get_ready
    @asks = Ask.nondeleted.normal.only(Ask::FIELDS).where(:user_id=>@user.id).desc(:created_at)
    @ret = @asks.skip((@page-1)*@per_page).limit(@per_page)
    render_this!
  end

  get '/:id/asked_to' do
    get_user("ask_to_me_ids")
    pagination_get_ready
    @asks = Ask.nondeleted.normal.only(Ask::FIELDS).any_in(:_id=>@user.ask_to_me_ids).desc(:created_at)
    @ret = @asks.skip((@page-1)*@per_page).limit(@per_page)
    render_this!
  end

  get '/:id/answered' do
    get_user
    pagination_get_ready
    @answers = Answer.nondeleted.only(Answer::FIELDS).where(:user_id=>@user.id)
    @ret = @answers.skip((@page-1)*@per_page).limit(@per_page)
    render_this!
  end
  
  get '/:id/comments' do
    get_user
    pagination_get_ready
    @comments = Comment.nondeleted.only(Comment::FIELDS).where(:user_id=>@user.id)
    @ret = @comments.skip((@page-1)*@per_page).limit(@per_page)
    render_this!
  end

  get '/:id/following' do
    slug=params[:id]
    user=User.nondeleted.only(:following_ids,:followed_ask_ids,:followed_topic_ids).where(:slug=>slug).first
    {users:user.following_ids,asks:user.followed_ask_ids,topics:user.followed_topic_ids}
  end

  get '/:id/followed' do
    slug=params[:id]
    user=User.nondeleted.only(:follower_ids).where(:slug=>slug).first
    user.follower_ids
  end
  
  get '/:id/suggestions' do
    slug=params[:id]
    if !api_super_client? and api_current_user_slug!=slug
      error!("Unauthorized access.", 401)
    end

    user=User.nondeleted.only(:followed_topic_ids,:following_ids).where(:slug=>slug).first
    if user and !(user.followed_topic_ids.blank? and user.following_ids.blank?)
      elim = (user.expert_type==User::EXPERT_USER or user.expert_type==User::ELITE_USER) ? 3 : 2
      ulim = (user.expert_type==User::EXPERT_USER or user.expert_type==User::ELITE_USER) ? 0 : 1
      tlim = 2
      usi = UserSuggestItem.where(:user_id=>user.id).first
      e = usi.suggested_experts
      u = usi.suggested_users
      t = usi.suggested_topics
      @suggested_experts =  User.nondeleted.only(User::FIELDS).any_in(:_id=>e.sort_by{rand}[0,elim]).not_in(:_id=>user.following_ids)
      @suggested_users = User.nondeleted.only(User::FIELDS).any_in(:_id=>u.sort_by{rand}[0,ulim]).not_in(:_id=>user.following_ids)
      @suggested_topics = Topic.nondeleted.only(Topic::FIELDS).any_in(:name=>t.sort_by{rand}[0,tlim])
    end
    {experts:@suggested_experts,users:@suggested_users,topics:@suggested_topics}
  end
end