class Admin::EventsController < AdminController
  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)

    if @event.save
      redirect_to new_admin_event_path, notice: "イベントを作成しました"
    else
      render :new, status: :unprocessable_content
    end
  end

  private
    def event_params
      params.expect(event: [ :name, :site_url, :thumbnail_url, :start_at, :end_at ])
    end
end
