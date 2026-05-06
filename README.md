# Kinos NixOS Configuration

Kinos 的 NixOS 配置文件，使用 Nix Flakes 和 Home Manager 进行系统级和用户级配置管理。

---

## 📁 项目结构

```
.
├── flake.nix                 # Flake 入口文件，定义输入源和系统配置
├── configuration.nix         # NixOS 主配置文件，导入所有模块
├── README.md                 # 项目说明文档（本文件）
├── .gitignore               # Git 忽略文件列表
├── modules/                 # 系统配置模块目录
│   ├── boot.nix            # 启动配置（bootloader、内核）
│   ├── networking.nix      # 网络配置（hostname、防火墙、NTP）
│   ├── localization.nix    # 本地化配置（时区、语言、字体）
│   ├── desktop.nix         # 桌面环境（GNOME、音频、输入法）
│   ├── users.nix           # 用户配置（账户、权限、Shell）
│   └── packages.nix        # 系统软件包配置
└── home/
    └── kinos/
        └── home.nix        # Home Manager 用户配置
```

---

## 🚀 快速开始

### 首次部署（新机器）

```bash
# 1. 克隆配置到 /etc/nixos
cd /etc/nixos
sudo git clone https://github.com/1443308677/nixos-config.git .

# 2. 生成硬件配置（如果缺失）
sudo nixos-generate-config --show-hardware-config > hardware-configuration.nix

# 3. 构建系统
sudo nixos-rebuild switch --flake .#nixos

# 4. 重启
sudo reboot
```

### 日常更新

```bash
# 进入配置目录
cd /etc/nixos

# 拉取最新配置
sudo git fetch origin main
sudo git checkout origin/main -- .
sudo rm -f flake.lock

# 重新构建
sudo nixos-rebuild switch --flake .#nixos
```

---

## ⚙️ 配置详情

### 系统配置（modules/）

| 模块 | 功能 | 关键配置 |
|------|------|----------|
| `boot.nix` | 启动配置 | systemd-boot、Linux 最新内核 |
| `networking.nix` | 网络配置 | hostname: nixos、NetworkManager、防火墙 |
| `localization.nix` | 本地化 | 上海时区、中文 UTF-8、Terminus 字体 |
| `desktop.nix` | 桌面环境 | GNOME + GDM、PipeWire 音频、fcitx5 输入法 |
| `users.nix` | 用户配置 | kinos 用户、Fish 默认 Shell |
| `packages.nix` | 软件包 | vim、git、htop、fastfetch、Firefox |

### 用户配置（home/kinos/home.nix）

- **用户名**: kinos
- **Shell**: Fish（系统级和用户级双重配置）
- **用户包**: Helix 编辑器
- **状态版本**: 25.11

---

## 🔧 Flake 输入源

| 输入 | 来源 | 用途 |
|------|------|------|
| `nixpkgs` | github:NixOS/nixpkgs/nixos-unstable | NixOS 包集合（不稳定分支） |
| `home-manager` | github:nix-community/home-manager | 用户级配置管理 |

---

## 📝 重要说明

### hardware-configuration.nix

- **此文件由 NixOS 自动生成**，包含硬件特定配置（磁盘分区、内核模块等）
- **每台机器不同**，已添加到 `.gitignore`，不会提交到 Git
- **首次安装时必须存在**，否则构建会失败

### Git 工作流

```
Windows (开发) → GitHub → NixOS (部署)
     ↑                              ↓
  修改配置                    拉取并重构
```

1. 在 Windows 上修改配置
2. 提交并推送到 GitHub
3. 在 NixOS 上拉取并重构

---

## 🛠️ 故障排除

### 构建失败：找不到 hardware-configuration.nix

```bash
# 生成硬件配置
sudo nixos-generate-config --show-hardware-config > hardware-configuration.nix
```

### Git 冲突或 flake.lock 问题

```bash
cd /etc/nixos
sudo git checkout origin/main -- .
sudo rm -f flake.lock
sudo nixos-rebuild switch --flake .#nixos
```

### 磁盘空间不足

```bash
# 清理旧版本
sudo nix-collect-garbage -d

# 或只删除 30 天前的
sudo nix-collect-garbage --delete-older-than 30d
```

---

## 📊 系统信息

部署成功后，运行 `fastfetch` 查看系统状态：

```
OS: NixOS 26.05 (Yarara) x86_64
Shell: fish 4.6.0
DE: GNOME 49.4
WM: Mutter (Wayland)
Locale: zh_CN.UTF-8
```

---

## 🔗 相关链接

- [NixOS 官方文档](https://nixos.org/manual/nixos/stable/)
- [Nix Flakes 手册](https://nixos.wiki/wiki/Flakes)
- [Home Manager 手册](https://nix-community.github.io/home-manager/)
- [NixOS 包搜索](https://search.nixos.org/packages)

---

## 📄 许可证

MIT License - 自由使用和修改
