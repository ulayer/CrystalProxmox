require "json"
require "http/client"

require "./access/access.cr"

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
      @connection_status = false
      @site = HTTP::Client.new(URI.parse(@pve_cluster))
      @auth_params = create_ticket()
    end

    def get(path)
      @site.get("/api2/json/#{path}", headers: HTTP::Headers{
        "User-Agent"          => "CrystalProxmox",
        "cookie"              => @auth_params["cookie"],
        "CSRFPreventionToken" => @auth_params["CSRFPreventionToken"],
      })
    end

    def post(path, args = Hash.new)
      @site.post("/api2/json/#{path}", args)
    end

    def put(path, args = Hash.new)
      @site.put("/api2/json/#{path}", args)
    end

    def delete(path, args = Hash.new)
      @site.delete("/api2/json/#{path}", args)
    end

    include CrystalProxmox::Access

    # TODO: Move this to nodes/tasks folder
    def task_status(taskid : String)
      data = self.get("nodes/#{@node}/tasks/#{taskid}/status")
      return data
    end
  end
end
