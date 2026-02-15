{ pkgs, inputs, ... }:
{

  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys =
  [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDTqg1h617IHbN4fUsyfSf42uX68xTcbleAMWyRN/VEDntc4ESAi4H8GnmTiJmjiKXT/DD119XkoVWaVStqgZfey1H8kjVi6EzKEFXs2Y6Tnz1Ad+tQwcgpIl/vvVHVSPSMu9J1VQIYGpE+wYEZf0NTuQHu1bBS0oEOKLv63nUIVystBuchy8pJg9fAPInWxqfU12hoZUWtx6ZLaO6h9hatiqxJht81pOwjv2PW8vflIYKDnMYjzqVzgPipqo7e3P7aKpqaCT6jgVkKnFXz72mNcvWsS0YoD2GxrE3qAGb9UWOV5Y+2oxjAlqILas6ejUQ/s3swnJDBRMHY82QwCTZpdq2RJm+pHFZf/lRX5RQpgiNURj2+YOl3NQaEjE4a7ZEBK2Gos72tXss/5stlDTsWpI445NXYOq8uk7yrkxKf1dKAJPNGzGR4kcB4iyvcZw5noAn1HbmpdK5W1u1ms65z9PV+RdVo7AlJnHdSe1lPxe+erepWI5UJpVxP9I/OkMs= bomal@nixos"
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 8;
  boot.loader.efi.canTouchEfiVariables = true;
  
}