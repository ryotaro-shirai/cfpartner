class Batch

  BATCH_LOG_PATH = Rails.root.join("log", "batch.log")
  BATCH_LOG_ROTATION = 'weekly'.freeze

  def initialize
    @logger = Logger.new(BATCH_LOG_PATH, BATCH_LOG_ROTATION)
    @logger.level = Logger::INFO
    exec
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
    end
  end

  private
  
    def update_status
      current_time = Time.current
      target_events = Event.where(cfp_status: [:no_information, :before_call, :now_on_call, :end_of_call])
      target_no_information_events = target_events.where("cfp_status = '0' AND cfp_start_at IS NOT NULL")
      target_before_call_events = target_events.where(cfp_status: :before_call, cfp_start_at: ..current_time)
      target_now_on_call_events = target_events.where(cfp_status: :now_on_call, cfp_end_at: ..current_time)
      target_end_of_call_events = target_events.where(cfp_status: :end_of_call, event_end_at: ..current_time)

      @logger.info "情報なし → CfP募集前：#{target_no_information_events.where(cfp_start_at: current_time..).count}件"
      target_no_information_events.where(cfp_start_at: current_time..).update_all(cfp_status: :before_call)
      @logger.info "情報なし → CfP募集中：#{target_no_information_events.where(cfp_start_at: ..current_time).count}件"
      target_no_information_events.where(cfp_start_at: ..current_time).update_all(cfp_status: :now_on_call)
      @logger.info "CfP募集前 → CfP募集中：#{target_before_call_events.count}件"
      target_before_call_events.update_all(cfp_status: :now_on_call)
      @logger.info "CfP募集中 → CfP募集終了：#{target_now_on_call_events.count}件"
      target_now_on_call_events.update_all(cfp_status: :end_of_call)
      @logger.info "CfP募集終了 → イベント終了：#{target_end_of_call_events.count}件"
      target_end_of_call_events.update_all(cfp_status: :end_of_event)
    end
end
