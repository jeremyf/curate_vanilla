module Curate::Deposit
  module WorksResponder
    def self.call(*args, &block)
      Base.call(*args, &block)
    end
    class Base < ActionController::Responder
      def to_html
        if get?
          render
        elsif has_errors?
          render :action => (post? ? :new : :edit)
        else
          redirect_to(controller.curate_deposit.work_path(resource.to_param) , { flash: { success: "Depositing #{resource}"} })
        end
      end
    end
  end
end
