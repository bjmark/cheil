class SolutionItemsController < ApplicationController
  before_filter :cur_user 

  def edit_price
    @solution_item = SolutionItem.find(params[:id])
    @solution_item.check_edit_right(@cur_user.org_id)
  end

  def update_price
  end
end
