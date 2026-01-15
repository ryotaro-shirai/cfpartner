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
      update_status
      @logger.info "ステータス更新バッチが正常に完了しました #{Time.current}"
    rescue => e
      @logger.info "ステータス更新バッチがエラーにより終了しました #{Time.current}"
      @logger.error e
      raise 
    end
  end

  private
  
    def update_status
      current_time = Time.current
      ActiveRecord::Base.transaction do

        count_target_end_of_call_events = Event.where(cfp_status: :end_of_call, event_end_at: ..current_time).update_all(cfp_status: :end_of_event)
        @logger.info "CfP募集終了 → イベント終了：#{count_target_end_of_call_events}件"

        count_target_now_on_call_events = Event.where(cfp_status: :now_on_call, cfp_end_at: ..current_time).update_all(cfp_status: :end_of_call)
        @logger.info "CfP募集中 → CfP募集終了：#{count_target_now_on_call_events}件"

        count_target_before_call_events = Event.where(cfp_status: :before_call, cfp_start_at: ..current_time).update_all(cfp_status: :now_on_call)
        @logger.info "CfP募集前 → CfP募集中：#{count_target_before_call_events}件"

        count_target_no_information_events_to_now = Event.where(cfp_status: :no_information).where(cfp_start_at: ..current_time).update_all(cfp_status: :now_on_call)
        @logger.info "情報なし → CfP募集中：#{count_target_no_information_events_to_now}件"

        count_target_no_information_events_to_before = Event.where(cfp_status: :no_information).where("cfp_start_at > ? ",current_time).update_all(cfp_status: :before_call)
        @logger.info "情報なし → CfP募集前：#{count_target_no_information_events_to_before}件"

      end
    end
end
