require 'cassandra'

class CassController < ApplicationController

  @@service = Service.new

  def index
    @data = @@service.query
    render json: JSON.pretty_generate(@data)
  end


  def create
    @data = @@service.insert(params[:first_name], params[:last_name])
    render json: JSON.pretty_generate(@data)
  end


  def destroy

    first_name = params['id']

    @data = @@service.delete(first_name)
    render json: JSON.pretty_generate(@data)
  end


end