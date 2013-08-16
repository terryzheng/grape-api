class GrapeAPI < Grape::API
  format :json
  
  helpers ApplicationHelper
  mount AskController => '/asks'
  mount HomeController
  mount TopicController => '/topics'
  mount UserController => '/users'

  before do
    @current_client = Client.where(:uri=>params[:client_id])
    if @current_client.count==0
      error!("#{request.ip} Unauthorized access.", 401)
    end
  end
  
  get '/' do
    @current_client.first.info+" in "+ENV['RACK_ENV']
  end
end
