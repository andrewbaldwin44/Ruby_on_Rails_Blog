class SupabaseService
    include HTTParty
  
    def initialize
        @api_key = Rails.application.credentials.SUPABASE_API_KEY
        @base_url = Rails.application.credentials.SUPABASE_URL
    end
  
    def sign_up(email, password)
      make_supabase_request('/auth/v1/signup', email: email, password: password)
    end
  
    def sign_in(email, password)
      make_supabase_request('/auth/v1/token?grant_type=password', email: email, password: password)
    end
  
    private
  
    def make_supabase_request(endpoint, body)
      self.class.post(
        "#{@base_url}#{endpoint}",
        headers: {
            "Content-Type" => "application/json",
            "Authorization" => "Bearer #{@api_key}",
            "apikey" => @api_key,
        },
        body: body.to_json
      )
    end
  end
  