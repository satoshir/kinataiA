class BasesController < ApplicationController
  def index
    @base = Base.all
  end
end
