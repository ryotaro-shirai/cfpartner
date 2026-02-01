class Batch

  BATCH_LOG_PATH = Rails.root.join("log", "batch.log")
  BATCH_LOG_ROTATION = 'weekly'.freeze

  def initialize
    @logger = Logger.new(BATCH_LOG_PATH, BATCH_LOG_ROTATION)
    @logger.level = Logger::INFO
  end
end

class UpdateStatusBatch < Batch
  def exec
    begin
      @logger.info "ステータス更新バッチが開始しました #{Time.current}"
      @logger.info "イベント情報の更新を開始しました #{Time.current}"
      update_events_status
      @logger.info "イベント情報の更新が正常に完了しました #{Time.current}"
      @logger.info "CfP募集情報の更新を開始しました #{Time.current}"
      update_talk_recruitments_status
      @logger.info "CfP募集情報の更新が正常に完了しました #{Time.current}"
      @logger.info "ステータス更新バッチが正常に完了しました #{Time.current}"
    rescue => e
      @logger.info "ステータス更新バッチがエラーにより終了しました #{Time.current}"
      @logger.error e
      raise 
    end
  end

  private
  
    def update_events_status
      current_time = Time.current
      ActiveRecord::Base.transaction do

        count_update_to_after_the_event = Event.where(end_at: ..current_time).where.not(status: :after_the_event).update_all(status: :after_the_event)
        @logger.info "after_the_event になったイベント数：#{count_update_to_after_the_event}件"

        count_update_to_now_on_the_event = Event.where(start_at: ..current_time, end_at: current_time..).where.not(status: :now_on_the_event).update_all(status: :now_on_the_event)
        @logger.info "now_on_the_event になったイベント数：#{count_update_to_now_on_the_event}件"

      end
    end

    def update_talk_recruitments_status
      current_time = Time.current
      ActiveRecord::Base.transaction do

        count_update_to_finished_call = Event.where(end_at: ..current_time).where.not(status: :finished_call).update_all(status: :finished_call)
        @logger.info "finished_call になった CfP募集情報数：#{count_update_to_finished_call}件"

        count_update_to_now_on_call = Event.where(start_at: ..current_time, end_at: current_time..).where.not(status: :now_on_call).update_all(status: :now_on_call)
        @logger.info "now_on_call になった CfP募集情報数：#{count_update_to_now_on_call}件"

        count_update_to_published_information = Event.where(start_at: current_time..).where.not(status: :published_information).update_all(status: :published_information)
        @logger.info "published_information になった CfP募集情報数：#{count_update_to_published_information}件"

      end
    end
end
