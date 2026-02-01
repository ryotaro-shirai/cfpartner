class Batch

  BATCH_LOG_PATH = Rails.root.join("log", "batch.log")
  BATCH_LOG_ROTATION = 'weekly'.freeze

  def initialize
    logdev =
      if Rails.env.production?
        $stdout
      else
        FileUtils.mkdir_p(BATCH_LOG_PATH.dirname)
        BATCH_LOG_PATH
      end

    @logger = Logger.new(logdev, BATCH_LOG_ROTATION)
    @logger.level = Logger::INFO
  end
end

class UpdateStatusBatch < Batch
  def exec
    begin
      current_time = Time.current
      @logger.info "ステータス更新バッチが開始しました #{Time.current}"
      ActiveRecord::Base.transaction do
        @logger.info "イベント情報の更新を開始しました #{Time.current}"
        update_events_status(current_time)
        @logger.info "イベント情報の更新が正常に完了しました #{Time.current}"
        @logger.info "CfP募集情報の更新を開始しました #{Time.current}"
        update_talk_recruitments_status(current_time)
        @logger.info "CfP募集情報の更新が正常に完了しました #{Time.current}"
      end
      @logger.info "ステータス更新バッチが正常に完了しました #{Time.current}"
    rescue => e
      @logger.info "ステータス更新バッチがエラーにより終了しました #{Time.current}"
      @logger.error e.full_message
      raise 
    end
  end

  private
  
    def update_events_status(current_time = Time.current)
      count_update_to_after_the_event = Event.where(end_at: ...current_time).where.not(status: :after_the_event).update_all(status: :after_the_event)
      @logger.info "after_the_event になったイベント数：#{count_update_to_after_the_event}件"

      count_update_to_now_on_the_event = Event.where(start_at: ..current_time, end_at: current_time..).where.not(status: :now_on_the_event).update_all(status: :now_on_the_event)
      @logger.info "now_on_the_event になったイベント数：#{count_update_to_now_on_the_event}件"
    end

    def update_talk_recruitments_status(current_time = Time.current)
      count_update_to_finished_call = TalkRecruitment.where(end_at: ...current_time).where.not(status: :finished_call).update_all(status: :finished_call)
      @logger.info "finished_call になった CfP募集情報数：#{count_update_to_finished_call}件"

      count_update_to_now_on_call = TalkRecruitment.where(start_at: ..current_time, end_at: current_time..).where.not(status: :now_on_call).update_all(status: :now_on_call)
      @logger.info "now_on_call になった CfP募集情報数：#{count_update_to_now_on_call}件"

      count_update_to_published_information = TalkRecruitment.where("start_at > ?", current_time).where.not(status: :published_information).update_all(status: :published_information)
      @logger.info "published_information になった CfP募集情報数：#{count_update_to_published_information}件"
    end
end
