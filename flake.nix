# ============================================
# Kinos NixOS Configuration Flake
# 配置入口文件，定义 Nix Flakes 输入和输出
# ============================================

{
  # Flake 描述信息
  description = "Kinos NixOS Configuration Flake";

  # Nix 配置选项（全局）
  nixConfig = { 
    allowUnfree = true;  # 允许使用非自由软件包
  };

  # ============================================
  # 输入源配置（inputs）
  # ============================================
  inputs = {
    # Nixpkgs 仓库 - 使用不稳定分支获取最新功能
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Home Manager - 用户级配置管理工具
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";  # 跟随 nixpkgs 版本
    };
  };

  # ============================================
  # 输出配置（outputs）
  # ============================================
  outputs = { self, nixpkgs, home-manager, ... }: {
    # NixOS 系统配置
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";           # 目标系统架构
      specialArgs = { inherit inputs; };  # 传递输入参数给模块

      # 导入配置模块
      modules = [
        # 主配置文件
        ./configuration.nix

        # Home Manager 集成配置
        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;    # 使用全局包集合
          home-manager.useUserPackages = true;  # 使用用户包集合
          home-manager.users.kinos = import ./home/kinos/home.nix;  # 用户配置
        }
      ];
    };
  };
}