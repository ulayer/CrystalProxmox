# CrystalProxmox

A library to manage Proxmox Hypervisors (Proxmox VE API - https://pve.proxmox.com/pve-docs/api-viewer/index.html) with Crystal. This library is experimental and methods (public, protected, and private) may added, changed, or removed at anytime without notice.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     CrystalProxmox:
       github: ulayer/CrystalProxmox
   ```

2. Run `shards install`

## Usage

```crystal
require "CrystalProxmox"
```

**If you need something that's not currently supported:** We are working on documentation and getting to a `1.0.0` release, it takes time and we are developing this in our free time. Meanwhile check the official api documentation and look for a corresponding method. If a method does not exist the `HTTP::Client` from the Crystal Standard Library should be enough to create a custom method for you. Consider the following example code. It even takes advantage of CrystalProxmox's ticket generation so you don't have to write your own :)

```crystal
my_proxmox_host = CrystalProxmox::Proxmox.new("https://your-proxmox-host.local:8006/", "name_name", "username", "password", "pve")
node = "nodename"
taskid = "taskid"
client = HTTP::Client.new(URI.parse("https://your-proxmox-host.local:8006/"))
client.get("/api2/json/nodes/#{node}/tasks/#{taskid}/status", headers: HTTP::Headers{
	"User-Agent"          => "CrystalProxmox",
	"cookie"              => my_proxmox_host.get_cookie,
	"CSRFPreventionToken" => my_proxmox_host.get_csrf_prevention_token,
})
```

If you've written custom code like this you think would benefit the community please open an issue and we'll consider inclusion in the library.

## Development

TODO: Write development instructions here

## Contributing

1. Fork it (<https://github.com/ulayer/CrystalProxmox/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Nathaniel Suchy](https://github.com/nsuchy) - creator and maintainer
