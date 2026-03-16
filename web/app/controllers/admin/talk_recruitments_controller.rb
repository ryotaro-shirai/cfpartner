class Admin::TalkRecruitmentsController < AdminController
  def new
    @talk_recruitment = TalkRecruitment.new
    @events = Event.all
  end

  def create
    @talk_recruitment = TalkRecruitment.new(talk_recruitment_params)

    if @talk_recruitment.save
      redirect_to new_admin_talk_recruitment_path, notice: "CfPを作成しました"
    else
      @events = Event.all
      render :new, status: :unprocessable_content
    end
  end

  private
    def talk_recruitment_params
      params.expect(talk_recruitment: [ :title, :site_url, :start_at, :end_at, :event_id ])
    end
end
