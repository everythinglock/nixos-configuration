# NixOS Configuration

我的个人 NixOS 系统配置仓库，记录了完整的系统环境设置。

## 📋 功能概述

这个仓库包含了一套完整的 NixOS 系统配置，主要特性包括：

### 核心功能
- **系统配置管理**：使用 Nix Flakes 进行声明式系统配置
- **GNOME 桌面环境**：搭配 GDM 显示管理器
- **硬件加速**：完整的 OpenGL 和 32 位应用支持
- **NVIDIA GPU 支持**：包括开源驱动和 PRIME 双 GPU 切换
- **电源管理**：细粒度电源管理以优化笔记本电池续航

### 输入法和字体
- **Fcitx5 输入法**：完整的中文输入支持（包括 Rime 输入法引擎）
- **多语言支持**：英文为主系统，中文语言和时区设置
- **专业字体**：JetBrains Mono、Sarasa Gothic 等字体集成

### 键盘增强
- **Keyd 键盘重映射**：
  - Caps Lock 短按为 Esc，长按为 Ctrl
  - 空格键作为导航层激活键
  - Vim 风格的 hjkl 导航快捷键

### 网络和工具
- **Clash Verge**：VPN 代理工具，支持 TUN 模式
- **NetworkManager**：灵活的网络管理
- **Niri 窗口管理器**：平铺窗口管理器支持（可选）

### 开发环境
- Neovim：终端编辑器
- Git：版本控制
- Firefox：浏览器
- 来自 unstable 频道的最新工具

## 🗂️ 项目结构

```
.
├── flake.nix                  # Nix Flakes 配置入口
├── flake.lock                 # 依赖版本锁定文件
├── configuration.nix          # 主系统配置文件
├── hardware-configuration.nix # 硬件配置（自动生成）
└── README.md                  # 本文件
```

### 文件说明

| 文件 | 说明 |
|------|------|
| **flake.nix** | Nix Flakes 定义文件，指定了 nixpkgs 和 unstable 频道的版本。使用 x86_64-linux 架构 |
| **configuration.nix** | 主配置文件，定义系统的大部分功能（桌面环境、驱动、应用程序等） |
| **hardware-configuration.nix** | 硬件配置文件（由 `nixos-generate-config` 生成），包括 LUKS 加密、磁盘挂载、CPU 类型等 |
| **flake.lock** | Flakes 依赖锁定文件，确保可复现的构建 |

## 🚀 使用方法

### 前置要求
- 已安装 NixOS 系统
- 已启用 Nix Flakes 支持

### 快速开始

1. **克隆配置仓库**
   ```bash
   git clone https://github.com/everythinglock/nixos-configuration.git
   cd nixos-configuration
   ```

2. **应用配置**
   ```bash
   sudo nixos-rebuild switch --flake .#nixos
   ```
   - `switch`：立即应用配置
   - `--flake .#nixos`：使用本地 flake.nix 中的 "nixos" 配置

3. **验证安装**
   ```bash
   nixos-version
   ```

### 常用命令

```bash
# 重建系统并应用配置
sudo nixos-rebuild switch --flake .#nixos

# 仅构建新配置但不立即应用
sudo nixos-rebuild build --flake .#nixos

# 更新锁定文件到最新版本
nix flake update

# 查看系统配置差异
sudo nixos-rebuild diff-closures --flake .#nixos
```

## ⚙️ 关键配置说明

### 显卡驱动配置

本配置支持 NVIDIA 和 AMD 集成显卡的 PRIME 双 GPU 切换：

```nix
# 需要根据你的实际硬件修改 Bus ID
nvidiaBusId = "PCI:1:0:0";
amdgpuBusId = "PCI:6:0:0";
```

**查询你的 GPU Bus ID：**
```bash
lspci | grep -E "VGA|3D"
```

### 主机名和网络

修改 `configuration.nix` 中的：
```nix
networking.hostName = "nixos";  # 改为你想要的主机名
```

### 用户账户

当前配置定义了用户 `fd`。如需修改：
```nix
users.users.fd = {
  isNormalUser = true;
  # ... 其他配置
};
```

### 启用额外功能

某些功能被注释掉了，可以按需启用：

- **SSH 服务器**：取消注释 `services.openssh.enable = true;`
- **打印支持**：已启用，配置在 `services.printing.enable = true;`
- **声卡支持**：默认启用 PipeWire

### 时区和语言

```nix
time.timeZone = "Asia/Shanghai";
i18n.defaultLocale = "en_US.UTF-8";
# LC_* 变量配置为 zh_CN.UTF-8（汉化系统选项）
```

## 🔧 自定义配置

### 添加新软件包

在 `environment.systemPackages` 中添加：

```nix
environment.systemPackages = with pkgs; [
  neovim
  git
  # 在这里添加更多包
];
```

### 使用 unstable 软件包

某些包已从 `nixpkgs-unstable` 引入：

```nix
_module.args.pkgsUnstable = pkgsUnstable;
environment.systemPackages = with pkgs; [
  pkgsUnstable.some-unstable-package
];
```

### 修改键盘映射

`services.keyd` 配置中可修改键盘行为：

```nix
services.keyd = {
  enable = true;
  keyboards = {
    default = {
      settings = {
        main = {
          # 修改键盘映射
        };
      };
    };
  };
};
```

## 📝 修改工作流

1. **编辑配置文件**：修改 `configuration.nix` 或其他配置文件
2. **构建新系统**：
   ```bash
   sudo nixos-rebuild switch --flake .#nixos
   ```
3. **检查结果**：验证功能是否正常
4. **回滚旧配置**（如需要）：
   ```bash
   sudo nixos-rebuild switch --flake ".#nixos" -p <previous-generation>
   ```

## 📚 学习资源

- [NixOS 官方文档](https://nixos.org/manual/)
- [Nix Flakes 入门](https://nixos.wiki/wiki/Flakes)
- [NixOS Wiki](https://nixos.wiki/)
- [Nixpkgs 手册](https://nixos.org/nixpkgs/)

## ⚠️ 注意事项

1. **hardware-configuration.nix**：这个文件由 NixOS 自动生成，不应手动编辑
2. **GPU Bus ID**：必须根据你的实际硬件修改，否则 PRIME 切换不可用
3. **LUKS 加密**：当前配置使用磁盘加密，启动时需要输入密码
4. **Unfree 软件**：已启用 `allowUnfree`，允许使用专有软件（如 NVIDIA 驱动）

## 🤝 反馈

如有问题或建议，欢迎提交 Issue 或 Pull Request！

---

**最后更新**：2026-04-26  
**NixOS 版本**：25.11  
**维护者**：@everythinglock
