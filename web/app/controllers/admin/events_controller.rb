class Admin::EventsController < AdminController
  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)

    if @event.save
      redirect_to new_admin_event_path, notice: "イベントを作成しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
    def event_params
      params.expect(event: [:name, :event_homepage_url, :event_start_at, :event_end_at, :url, :cfp_start_at, :cfp_end_at, :image_url])
    end
end