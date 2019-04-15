require "json"
require "http/client"

# TODO: Write documentation for `CrystalProxmox`
module CrystalProxmox
  VERSION = "0.1.0"

  class Proxmox
    @auth_params : Hash(String, String)

    def initialize(pve_cluster : String, node : String, username : String, password : String, realm : String)
      @pve_cluster = pve_cluster # https://your-proxmox-server.local:8006/api2/json/
      @node = node               # node
      @username = username       # root
      @password = password       # password
      @realm = realm             # pve
      @connection_status = "error"
      @site = HTTP::Client.new(URI.parse(@pve_cluster))
      @auth_params = create_ticket()
    end

    def get(path, args = Hash.new)
      nil
    end

    def post(path, args = Hash.new)
      @site.post "/api2/json/#{path}"
    end

    def put(path, args = Hash.new)
      nil
    end

    def delete(path, args = Hash.new)
      nil
    end

    def show_ticket
      @auth_params["cookie"]
    end

    def create_ticket : Hash(String, String)
      response = @site.post("/api2/json/access/ticket")
      extract_ticket(response)
    end

    def extract_ticket(response : Object) : Hash(String, String)
      data = JSON.parse(response.body)
      ticket = data["data"]["ticket"]
      csrf_prevention_token = data["data"]["CSRFPreventionToken"]
      token = "PVEAuthCookie=" + ticket.as_s.gsub(/:/, "%3A").gsub(/=/, "%3D")
      @connection_status = "connected"
      return {
        "CSRFPreventionToken" => csrf_prevention_token.as_s,
        "cookie"              => token,
      }
    end
  end
end
