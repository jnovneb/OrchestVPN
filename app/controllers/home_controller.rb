class HomeController < ApplicationController


#  before_action :authenticate_admin!, only: [:action] # `only` part if applicable

  def index
    @vpns = Vpn.all
  end

  def show
    @vpn = Vpn.find(params[:id])
  end
end