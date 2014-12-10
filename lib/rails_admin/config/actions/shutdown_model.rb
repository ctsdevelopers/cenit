module RailsAdmin
  module Config
    module Actions
      class ShutdownModel < RailsAdmin::Config::Actions::Base

        register_instance_option :only do
          Setup::DataType
        end

        register_instance_option :member do
          true
        end

        register_instance_option :http_methods do
          [:get]
        end

        register_instance_option :visible do
          authorized? && bindings[:object].loaded?
        end

        register_instance_option :controller do
          proc do
            if model = @object.model
              begin
                @object.auto_load_model = @object.activated = false
                @object.save
                Setup::Schema.shutdown_data_type_model(@object)
                flash[:success] = "Shutdown model #{@object.name} success"
              rescue Exception => ex
                flash[:error] = "Error shutdown model #{@object.name}: #{ex.message}"
              end
            else
              flash[:notice] = "Model #{@object.name} is not loaded"
            end
            redirect_to back_or_index
          end
        end

        register_instance_option :link_icon do
          'icon-off'
        end

        register_instance_option :pjax? do
          false
        end
      end
    end
  end
end