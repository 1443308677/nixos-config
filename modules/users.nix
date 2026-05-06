# ============================================
# 用户配置模块
# 配置系统用户账户和权限
# ============================================

{ config, pkgs, ... }:

{
  # ============================================
  # 用户账户配置
  # ============================================
  users.users.kinos = {
    isNormalUser = true;              # 创建普通用户（非系统用户）
    description = "Kinos Li";         # 用户描述信息
    home = "/home/kinos";             # 用户家目录路径
    createHome = true;                # 自动创建家目录
    extraGroups = [                   # 附加用户组
      "wheel"           # 允许使用 sudo 权限
      "networkmanager"  # 允许管理网络连接
    ];
    ignoreShellProgramCheck = true;   # 忽略 Shell 程序检查（由 Home Manager 管理）
  };

  # ============================================
  # Fish Shell 配置（系统级别）
  # ============================================
  programs.fish.enable = true;  # 启用 Fish Shell（基础配置）
}
