# Kinos NixOS 配置

使用 Nix Flakes + Home Manager 管理的 NixOS 系统配置。

---

## 项目结构

```
.
├── flake.nix              # Flake 入口
├── configuration.nix      # 主配置（导入所有模块）
├── modules/               # 系统模块
│   ├── boot.nix          # 启动、内核
│   ├── networking.nix    # 网络、防火墙
│   ├── localization.nix  # 时区、语言
│   ├── desktop.nix       # GNOME、音频、输入法
│   ├── users.nix         # 用户、Shell
│   └── packages.nix      # 系统软件包
└── home/kinos/home.nix   # 用户配置
```

**注意**：`hardware-configuration.nix`（硬件配置）由每台机器自动生成，已加入 `.gitignore`，不在 GitHub 上。

---

## 使用场景

### 1. 全新系统部署

```bash
cd /etc/nixos

# 1. 备份硬件配置到临时目录
mv hardware-configuration.nix /tmp/

# 2. 清空当前目录
rm -rf *

# 3. 克隆你的配置
git clone https://github.com/1443308677/nixos-config.git .

# 4. 恢复硬件配置
mv /tmp/hardware-configuration.nix .

# 5. 应用配置并重启
sudo nixos-rebuild switch --flake .#nixos
sudo reboot
```

### 2. 日常更新

```bash
cd /etc/nixos

# 1. 获取远程最新代码
sudo git fetch origin main

# 2. 强制覆盖本地文件
sudo git checkout origin/main -- .

# 3. 删除锁文件（避免版本冲突）
sudo rm -f flake.lock

# 4. 应用配置
sudo nixos-rebuild switch --flake .#nixos
```

### 3. 放弃本地修改

```bash
cd /etc/nixos

# 1. 强制恢复到远程版本
sudo git reset --hard origin/main

# 2. 删除锁文件
sudo rm -f flake.lock

# 3. 重新构建
sudo nixos-rebuild switch --flake .#nixos
```

---

## 配置概览

| 模块 | 功能 |
|------|------|
| boot | systemd-boot、Linux 最新内核 |
| networking | hostname: nixos、NetworkManager、防火墙 |
| localization | 上海时区、中文 UTF-8 |
| desktop | GNOME + GDM、PipeWire、fcitx5 输入法 |
| users | kinos 用户、Fish 默认 Shell |
| packages | vim、git、htop、fastfetch、Firefox |

**用户配置**：Helix 编辑器

---

## 故障排除

| 问题 | 解决 |
|------|------|
| 找不到 hardware-configuration.nix | `sudo nixos-generate-config --show-hardware-config > hardware-configuration.nix` |
| 磁盘空间不足 | `sudo nix-collect-garbage -d` |
| 构建失败 | 删除 `flake.lock` 重试 |

---

## 系统信息

```
OS: NixOS 26.05 (Yarara)
Shell: fish 4.6.0
DE: GNOME 49.4
Locale: zh_CN.UTF-8
```
