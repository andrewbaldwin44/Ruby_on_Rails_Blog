class SupabaseService
    include HTTParty
  
    def initialize
        @api_key = Rails.application.credentials.SUPABASE_API_KEY
        @base_url = Rails.application.credentials.SUPABASE_URL
        @public_storage_bucket = Rails.application.credentials.SUPABASE_PUBLIC_STORAGE_BUCKET
    end
  
    def sign_up(email, password)
      make_supabase_request("/auth/v1/signup", {email: email, password: password}, is_form: false)
    end
  
    def sign_in(email, password)
      make_supabase_request("/auth/v1/token?grant_type=password", {email: email, password: password}, is_form: false)
    end

    def upload_image(file, user_id)
      extension = File.extname(file.original_filename)
      filename = "#{SecureRandom.uuid}#{extension}"
      storage_path = "/storage/v1/object"

      response = make_supabase_request("#{storage_path}/#{@public_storage_bucket}/#{user_id}/#{filename}", {file: file}, is_form: true)
   
      if response.success?
        "#{@base_url}#{storage_path}/public/#{@public_storage_bucket}/#{user_id}/#{filename}"
      else
        # Handle the case where the image upload failed
        puts "Image upload failed: #{response.code} - #{response.parsed_response}"
      end
    end
  
    private
  
    def make_supabase_request(endpoint, body, is_form: false)
      headers = {
        'Content-Type' => is_form ? 'multipart/form-data' : 'application/json',
        'Authorization' => "Bearer #{@api_key}",
        'apikey' => @api_key
      }

      request_body = is_form ? body : body.to_json

      self.class.post(
        "#{@base_url}#{endpoint}",
        headers: headers,
        body: request_body
      )
    end
  end
  