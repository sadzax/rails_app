class VmControlJob
  include Sidekiq::Job

  def perform(*args)
    StopVmService.call(order_id)
  end
end
