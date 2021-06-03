RSpec.describe ApplicationController, type: :controller do
  controller do
    enable_request_formats json: :json, js_or_atom: %i[js atom]
    protect_from_forgery except: :js_or_atom
    around_action :switch_locale

    def test
      render html: "ok"
    end

    def locale_check
      render html: I18n.locale
    end

    def json
      respond_to do |format|
        format.html { render body: "html" }
        format.json { render body: "{}" }
      end
    end

    def js_or_atom
      respond_to do |format|
        format.html  { render body: "html" }
        format.js    { render body: "javascript" }
        format.atom  { render body: "atom" }
      end
    end
  end

  def with_test_routing
    routes.draw do
      get "/test" => "anonymous#test"
      get "/locale" => "anonymous#locale_check"
      get "/test" => "anonymous#json"
      get "/test" => "anonymous#js_or_atom"
    end
    yield
  end

  it "allows HTML or wildcard requests by default" do
    mime_types = ["text/html", "application/xhtml+xml", "*/*"]

    with_test_routing do
      mime_types.each do |type|
        @request.env["HTTP_ACCEPT"] = type

        get :test

        expect(response.status).to eq(200)
        expect(response.media_type).to eq(Mime[:html].to_s)
      end
    end
  end

  it "rejects non-HTML requests by default" do
    with_test_routing do
      %i[json xml atom].each do |format|
        get :test, format: format

        expect(response).to have_http_status(:not_acceptable)
      end
    end
  end

  it "allows additional formats which are explicitly enabled" do
    with_test_routing do
      get :json
      expect(response).to have_http_status(:success)
      expect(response.media_type).to eq(Mime[:html])
      expect(response.body).to eq("html")

      get :json, format: :json
      expect(response).to have_http_status(:success)
      expect(response.media_type).to eq(Mime[:json])
      expect(response.body).to eq("{}")

      get :json, format: :atom
      expect(response).to have_http_status(:not_acceptable)
    end
  end

  it "allows multiple formats which are explicitly enabled" do
    with_test_routing do
      get :js_or_atom
      expect(response).to have_http_status(:success)
      expect(response.media_type).to eq(Mime[:html])
      expect(response.body).to eq("html")

      get :js_or_atom, format: :js
      expect(response).to have_http_status(:success)
      expect(response.media_type).to eq(Mime[:js])
      expect(response.body).to eq("javascript")

      get :js_or_atom, format: :atom
      expect(response).to have_http_status(:success)
      expect(response.media_type).to eq(Mime[:atom])
      expect(response.body).to eq("atom")

      get :js_or_atom, format: :json
      expect(response).to have_http_status(:not_acceptable)
    end
  end

  it "returns an appropriate response for unrecognised/invalid request formats" do
    with_test_routing do
      get :test, format: "atom\\"
      expect(response).to have_http_status(:not_acceptable)
    end
  end

  it "changes locale only for the duration of the request" do
    with_test_routing do
      get :locale_check, params: { locale: "cy" }
      expect(response).to have_http_status(:success)
      expect(response.body).to eq("cy")

      expect(I18n.locale).to eq(:en)
    end
  end
end
