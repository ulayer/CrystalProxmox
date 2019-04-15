require "../CrystalProxmox.cr"

module CrystalProxmox::Access
  def get_cookie
    @auth_params["cookie"]
  end

  def get_csrf_prevention_token
    @auth_params["CSRFPreventionToken"]
  end

  def create_ticket : Hash(String, String)
    response = @site.post("/api2/json/access/ticket", body: "username=#{@username}&password=#{@password}&realm=#{@realm}")
    extract_ticket(response)
  end

  def extract_ticket(response : Object) : Hash(String, String)
    data = JSON.parse(response.body)
    ticket = data["data"]["ticket"]
    csrf_prevention_token = data["data"]["CSRFPreventionToken"]
    token = "PVEAuthCookie=" + ticket.as_s.gsub(/:/, "%3A").gsub(/=/, "%3D")
    @connection_status = true
    return {
      "CSRFPreventionToken" => csrf_prevention_token.as_s,
      "cookie"              => token,
    }
  end
end
