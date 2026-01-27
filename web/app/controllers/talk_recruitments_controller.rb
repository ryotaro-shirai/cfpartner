class TalkRecruitmentsController < ApplicationController
  def index
    @talk_recruitments = TalkRecruitment.eager_load(:event).all
  end
end
