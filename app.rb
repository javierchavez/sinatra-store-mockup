require 'rubygems'
require 'sinatra'


configure do
  set :public_folder, Proc.new { File.join(root, "static") }
  enable :sessions
end

helpers do
  def username
    session[:username] ? session[:username] : nil
  end

  def cart
    session[:cart] ? session[:cart] : '0'
  end
end

before '/secure/*' do
  if !session[:username] then
    session[:previous_url] = request.path
    @error = 'Sorry guacamole, you need to be logged in to visit ' + request.path
    halt erb(:login_form)
  end
end

get '/' do
  erb :home, :layout => false
end

get '/store' do
  erb :store
end

get '/who-we-are' do
  erb :us
end

get '/links' do
  erb "We will have links here"
end


get '/login/form' do 
  erb :login_form
end

get '/logout' do
  session.delete(:username)
  session.delete(:cart)
  erb "<div class='alert alert-message'>Logged out</div>"
  redirect to '/' 
end

post '/login/attempt' do
  session[:username] = params['username']
  redirect to '/store'
end

post '/secure/store/add' do
  session[:cart] = session[:cart].to_f + params['item'].to_f
  redirect to '/store'
end


