# ============================================
# 桌面环境配置模块
# 配置图形服务、桌面环境、音频和输入法
# ============================================

{ config, pkgs, ... }:

{
  # ============================================
  # 图形服务配置
  # ============================================
  services.xserver.enable = true;                 # 启用 Xorg 图形服务
  services.displayManager.gdm.enable = true;      # 使用 GDM 作为显示管理器
  services.desktopManager.gnome.enable = true;    # 使用 GNOME 桌面环境
  services.accounts-daemon.enable = true;         # 启用用户账户管理服务

  # ============================================
  # 音频配置（PipeWire）
  # ============================================
  services.pulseaudio.enable = false;  # 禁用 PulseAudio（使用 PipeWire 替代）
  services.pipewire = {
    enable = true;                    # 启用 PipeWire
    alsa.enable = true;               # 启用 ALSA 支持
    alsa.support32Bit = true;         # 支持 32 位应用
    pulse.enable = true;              # 兼容 PulseAudio 应用
  };

  # ============================================
  # 中文输入法配置（fcitx5）
  # ============================================
  i18n.inputMethod = {
    type = "fcitx5";  # 使用 fcitx5 输入法框架
    fcitx5.addons = with pkgs; [
      fcitx5-rime                        # Rime 输入法引擎
      qt6Packages.fcitx5-chinese-addons  # Qt6 中文输入支持
    ];
  };

  # ============================================
  # 其他桌面服务
  # ============================================
  services.printing.enable = true;               # 启用打印服务（CUPS）
  virtualisation.vmware.guest.enable = true;     # VMware 虚拟机优化支持
}