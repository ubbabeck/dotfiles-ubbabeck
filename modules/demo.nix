{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.ruben.demo;
in
{
  options.ruben.demo = {
    enable = lib.mkEnableOption "Enable or disable the demo module.";

    message = lib.mkOption {
      type = lib.types.str;
      default = "Hello, world!";
      description = "A message to display.";
    };

    greetings = lib.mkOption {
      description = "The list of greetings";
      type = lib.types.listOf (
        lib.types.submodule (
          { config, ... }:
          {
            options = {
              name = lib.mkOption {
                description = "The name of the person to greet.";
                type = lib.types.str;
              };
              message = lib.mkOption {
                description = "The greeting for that person, default to `Hello <name>`";
                type = lib.types.str;
                default = "Hello ${config.name}";
              };
              path = lib.mkOption {
                description = "The paths to display";
                type = lib.types.str;
                default = "${config.name}";
              };
            };
          }
        )
      );

    };

    server = {

      port = lib.mkOption {
        type = lib.types.port;
        default = 8080;
        description = "The port for the demo sever";
      };
    };
    package = lib.mkPackageOption pkgs "python3" { };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.demo-server =
      let
        server = pkgs.writeText "demo-server.py" (
          ''
            from http.server import BaseHTTPRequestHandler, HTTPServer
            class RequestHandler(BaseHTTPRequestHandler):
                def do_GET(self):
                    response = "${cfg.message}"
          ''
          + (lib.concatLines (
            lib.map (
              g: "        if self.path == '/${g.name}':\n            response = '${g.message}'\n"
            ) cfg.greetings
          ))
          + ''


                    # Send response status code
                    self.send_response(200)

                    # Send headers
                    self.send_header("Content-type", "text/plain")
                    self.end_headers()
                    # Send the response body
                    self.wfile.write(response.encode())

            def run(server_class=HTTPServer, handler_class=RequestHandler, port=${toString cfg.server.port}):
                server_address = ("", port)
                httpd = server_class(server_address, handler_class)
                print(f"Starting server on port {port}...")
                httpd.serve_forever()

            if __name__ == '__main__':
                run()
          ''
        );
      in
      {
        description = "Demo Python Server";
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          ExecStart = "${lib.getExe cfg.package} ${server}";
          Restart = "always";
        };
      };

  };

}
