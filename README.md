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

## 🚀 使用场景指南

### 场景一：全新 NixOS 系统（首次部署）

适用于新安装的 NixOS 系统，或想完全替换现有配置。

```bash
# 1. 备份原配置（重要！）
sudo mv /etc/nixos /etc/nixos.backup.$(date +%Y%m%d)

# 2. 创建新目录并克隆配置
sudo mkdir /etc/nixos
cd /etc/nixos
sudo git clone https://github.com/1443308677/nixos-config.git .

# 3. 生成当前机器的硬件配置
sudo nixos-generate-config --show-hardware-config > hardware-configuration.nix

# 4. 构建系统
sudo nixos-rebuild switch --flake .#nixos

# 5. 重启
sudo reboot
```

**注意事项：**
- 确保用户名与配置一致（默认 `kinos`），否则修改 `modules/users.nix` 和 `home/kinos/home.nix`
- 确保 hostname 一致（默认 `nixos`），否则修改 `modules/networking.nix`

---

### 场景二：日常更新配置（已部署系统）

适用于已运行此配置的 NixOS 系统，从 GitHub 拉取最新更新。

```bash
# 1. 进入配置目录
cd /etc/nixos

# 2. 拉取最新配置（强制覆盖本地修改）
sudo git fetch origin main
sudo git checkout origin/main -- .

# 3. 删除 flake.lock 重新生成（避免版本冲突）
sudo rm -f flake.lock

# 4. 重新构建系统
sudo nixos-rebuild switch --flake .#nixos
```

**什么时候需要更新？**
- 在 Windows 上修改了配置并推送到 GitHub
- 想同步最新的软件包版本
- 添加了新的功能模块

---

### 场景三：本地修改后恢复（放弃本地更改）

适用于在 NixOS 上直接修改了配置，但想放弃更改恢复远程版本。

```bash
cd /etc/nixos

# 强制恢复远程版本
sudo git reset --hard origin/main
sudo rm -f flake.lock
sudo nixos-rebuild switch --flake .#nixos
```

---

### 场景四：修改配置后推送（在 NixOS 上开发）

适用于直接在 NixOS 上修改配置，并推送到 GitHub。

```bash
cd /etc/nixos

# 1. 修改配置文件（用 nano/vim 等）
sudo nano modules/packages.nix

# 2. 测试构建
sudo nixos-rebuild switch --flake .#nixos

# 3. 如果成功，提交并推送
sudo git add .
sudo git commit -m "添加 xxx 软件包"
sudo git push origin main
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

### 用户名/hostname 不匹配

```bash
# 修改用户名（修改后重新构建）
sudo nano /etc/nixos/modules/users.nix
sudo nano /etc/nixos/home/kinos/home.nix

# 修改 hostname
sudo nano /etc/nixos/modules/networking.nix
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
