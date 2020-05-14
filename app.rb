require 'sinatra/base'
require "sinatra/config_file"
require './models/user.rb'
class App < Sinatra::Base
  register Sinatra::ConfigFile
  config_file 'config/config.yml'
  configure :development, :production do
    enable :logging
  end
  get "/" do # Shows how to access to settings configurations
    logger.info "params"
    logger.info params
    logger.info "--------------"
    logger.info "Configurations"
    logger.info settings.db_adapter
    logger.info "--------------"
  end

  get "/login" do
    erb :login
  end
  post "/login" do
    usuario = User.find(userName: params["userName"])
    if usuario.password == params["password"]
      redirect "/profile"
    else
      @error ="Your username o password is incorrect"
      redirect "login"
    end
  end

  get "/create_user" do
    erb:create_user
  end
  post "/create_user" do
    if user2 = User.find(userName: params["userName"])
      [500, {}, "ya existe el usuario"]
    else
      user = User.new(name: params['name'],surnames: params['surnames'],dni: params['dni'],userName: params['userName'],password: params['password'])
      if user.save
           redirect "/profile"
       else
           [500, {}, "Internal Server Error"]
           redirect "/create_user"
      end
    end
  end

  get "/profile" do
    erb:profile
  end

  get "/create_document" do
    @userCreate = User.all
    @categories = Category.all
    erb:create_document
  end

  post "create document" do
    @filename = params[:PDF][:filename]
    file = params[:PDF][:tempfile]
    File.open("./PDF/#{@filename}", 'wb') do |f|
      f.write(file.read)
    end
    @filename
      #chosenTagged = params[:tagged]
      #chosenCategory = Category.find(name: params[:category])
      #document = Document.new(name: params[name], file: params[file], description: params[description], category_id: chosenCategory.id)
      #document.save
      #chosenTagged.each do |element|
      #  doc_us = Document_user.new(document_id: document.id, user_id: element.id)
      #  doc_us.save
      #end
      redirect "/create_document"
  end

  get "/create_category" do
    erb:create_category
  end
end
