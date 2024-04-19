Rails.application.config.middleware.use OmniAuth::Builder do
    OmniAuth.config.allowed_request_methods = [:post, :get]
    OmniAuth.config.request_validation_phase = Proc.new { |env| }
    OmniAuth.config.silence_get_warning = true
end