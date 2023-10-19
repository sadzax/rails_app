module Api
    class ReportsController < ApplicationController
      def create
        report = Report.create(report_params)
        ReportGenerationJob.perform_async(report.report_name)
        render json: { status: 'Отчёт формируется' }
      end

      private

      def report_params
        params.require(:order).permit(:report_name, :quantity, :hdd_type)
      end
    end
end