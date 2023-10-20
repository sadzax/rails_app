class ReportGenerationJob
    include Sidekiq::Worker
  
    def perform(report_name)
      report = Report.find(report_name)
      # Обращение к сервису для получения данных
      generated_data = `ruby ~/pr/hw1/reports.rb`
  
      # сохранение данных в отчет
      report.update(generated_data: generated_data)
    end
  end