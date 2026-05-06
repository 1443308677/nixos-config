# ============================================
# 系统启动配置模块
# 配置 bootloader 和内核相关选项
# ============================================

{ config, pkgs, ... }:

{
  # ============================================
  # 启动加载器配置（Bootloader）
  # ============================================
  boot.loader.systemd-boot.enable = true;  # 使用 systemd-boot 作为 bootloader
  boot.loader.efi.canTouchEfiVariables = true;  # 允许修改 EFI 变量（适用于 UEFI 系统）

  # ============================================
  # 内核配置
  # ============================================
  boot.kernelPackages = pkgs.linuxPackages_latest;  # 使用最新稳定内核
}