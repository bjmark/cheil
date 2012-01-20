class PagesController < ApplicationController
  before_filter :cur_user

  def show
    render params[:id]
  end
end
