class PagesController < ApplicationController
  def home
    @group = Group.all
  end

  def count
    @group = Group.find(params[:id])
  end
end
