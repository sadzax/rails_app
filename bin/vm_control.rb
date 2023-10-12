require 'bunny'
require './app/services/stop_vm_service'

connection = Bunny.new('amqp://guest:guest@rabbitmq')
connection.start

channel = connection.create_channel
queue = channel.queue('vm.control')

begin
    queue.subscribe(block: true) do |_delivery_info, _metadata, payload|
        StopVmService.call(payload)
    end
rescue Interrupt => _
    connection.close
end
