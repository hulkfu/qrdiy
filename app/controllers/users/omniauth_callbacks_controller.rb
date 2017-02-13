class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # You should configure your model like this:
  # devise :omniauthable, omniauth_providers: [:twitter]

  # You should also create an action method in this controller like this:
  # def twitter
  # end

  def self.handle_omniauth(*providers)
    providers.each do |provider|
      define_method provider do
        user = User.from_omniauth(request.env["omniauth.auth"])
        if user.persisted?
          sign_in_and_redirect user, notice: "登录成功。"
        else
          redirect_to user_root_path, alert: "请重新登录。"
        end
      end
    end
  end

  handle_omniauth :wechat, :weibo

  # More info at:
  # https://github.com/plataformatec/devise#omniauth

  # GET|POST /resource/auth/twitter
  # def passthru
  #   super
  # end

  # GET|POST /users/auth/twitter/callback
  # def failure
  #   super
  # end

  # protected

  # The path used when OmniAuth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end
end
