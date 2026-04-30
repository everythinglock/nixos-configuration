# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  lib,
  pkgs,
  pkgsUnstable,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
  ];

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];

    substituters = lib.mkBefore [
      "https://mirror.nju.edu.cn/nix-channels/store"
      "https://mirror.tuna.tsinghua.edu.cn/nix-channels/store"
      "https://cache.nixos.org"
    ];

    trusted-users = [
      "root"
      "@wheel"
    ];
  };

  # Bootloader
  boot.loader.limine = {
    enable = true;
    style = {
      # 隐藏顶部的按键提示
      interface.helpHidden = true;

      # 清空壁纸，使用纯色背景
      wallpapers = [ ];

      # Catppuccin Mocha 深色终端配色
      graphicalTerminal = {
        # 标准色: 黑, 红, 绿, 棕, 蓝, 洋红, 青, 灰
        palette = "1e1e2e;f38ba8;a6e3a1;f9e2af;89b4fa;f5c2e7;94e2d5;cdd6f4";
        # 亮色: 深灰, 亮红, 亮绿, 黄, 亮蓝, 亮洋红, 亮青, 白
        brightPalette = "585b70;f38ba8;a6e3a1;f9e2af;89b4fa;f5c2e7;94e2d5;a6adc8";

        # 背景色和前景色
        background = "1e1e2e"; # 深邃的暗背景
        foreground = "cdd6f4"; # 柔和的亮灰白文本

        brightBackground = "1e1e2e";
        brightForeground = "f5e0dc"; # 带一丝粉调的亮色文本
      };
    };
  };
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  hardware = {
    # 启用OpenGL
    graphics = {
      enable = true;
      enable32Bit = true; # 支持32位应用
    };
    enableRedistributableFirmware = true; # 可分发固件（显卡、网卡固件）
    # 根据cpu型号选择，全开可保持在不同机器上的兼容
    cpu.amd.updateMicrocode = true;
    cpu.intel.updateMicrocode = true;
    nvidia = {
      open = true; # 官方开源驱动，仅新卡可用
      modesetting.enable = true; # 开启modesetting内核，配合prime工具
      nvidiaSettings = true; # 安装nvidia-setting gui工具
      # 选择驱动版本stable
      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true; # 生成一个nvidia-offload命令
        };
        # 重要：用 lspci | grep -E "VGA|3D" 查询实际 Bus ID
        nvidiaBusId = "PCI:1:0:0";
        amdgpuBusId = "PCI:6:0:0";
      };
      # 电源管理
      powerManagement.enable = true;
      powerManagement.finegrained = true; # 细粒度电源管理
    };
  };
  # 默认调用nvidia，无nvidia会退回其他驱动
  services.xserver.videoDrivers = [ "nvidia" ];

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "zh_CN.UTF-8";
      LC_IDENTIFICATION = "zh_CN.UTF-8";
      LC_MEASUREMENT = "zh_CN.UTF-8";
      LC_MONETARY = "zh_CN.UTF-8";
      LC_NAME = "zh_CN.UTF-8";
      LC_NUMERIC = "zh_CN.UTF-8";
      LC_PAPER = "zh_CN.UTF-8";
      LC_TELEPHONE = "zh_CN.UTF-8";
      LC_TIME = "zh_CN.UTF-8";
    };
  };

  fonts = {
    packages = with pkgs; [
      jetbrains-mono
      sarasa-gothic
      nerd-fonts.jetbrains-mono
    ];

    fontconfig = {
      defaultFonts = {
        monospace = [
          "JetBrains Mono"
          "Sarasa Gothic SC"
        ];
        sansSerif = [ "Sans Serif" ];
        serif = [ "Serif" ];
      };
    };
  };

  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = [ "*" ]; # 应用到所有键盘
        settings = {
          main = {
            capslock = "overload(control, esc)"; # 短按 Esc，长按 Ctrl
            space = "overload(nav, space)"; # 短按空格，长按导航层
            rightalt = "overload(nums, enter)"; # 短按enter，长按数字层
            apostrophe = "overload(shift, apostrophe)";
          };
          nav = {
            # 导航层（按住空格时激活）
            j = "down";
            k = "up";
            h = "left";
            l = "right";
            a = "home";
            e = "end";
            f = "pageup";
            b = "pagedown";
            # 输入层
            s = "space";
            y = "=";
            u = "+";
            i = "-";
            o = "*";
            p = "/";
            r = "(";
            t = ")";
            apostrophe = "|";
            v = "~";
            w = "enter";
            n = "backspace";
            m = "del";
          };
          nums = {
            # 数字
            a = "1";
            s = "2";
            d = "3";
            f = "4";
            g = "5";
            h = "6";
            j = "7";
            k = "8";
            l = "9";
            semicolon = "0";
            n = "backspace";
          };
        };
      };
    };
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.fd = {
    isNormalUser = true;
    description = "fd";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = [
      #  thunderbird
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  _module.args.pkgsUnstable = pkgsUnstable;
  environment.systemPackages = with pkgs; [
    gnumake
    neovim
    git
    pkgsUnstable.noctalia-shell
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  # v2raya,端口localhost:2017
  services.v2raya.enable = true;
  # networking.firewall.allowedTCPPorts = [ 2017 ];
  # networking.firewall.allowedUDPPorts = [ 2017 ];
  # tun模式需要修改防火墙设置
  # networking.firewall.checkReversePath = "loose";
  # networking.firewall.trustedInterfaces = [ "tun0" ]; # 根据ip a的结果修改成对应名字

  programs.niri = {
    enable = true;
    package = pkgsUnstable.niri;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
