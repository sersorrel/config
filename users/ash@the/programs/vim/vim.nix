{ lib, pkgs, ... }:

let
  vim-angry = pkgs.vimUtils.buildVimPlugin {
    name = "vim-angry";
    src = pkgs.fetchFromGitHub {
      owner = "b4winckler";
      repo = "vim-angry";
      rev = "08e9e9a50e6683ac7b0c1d6fddfb5f1235c75700";
      sha256 = "0cxfvzlka0pgqs2ij4vwfv97yqks2ncnzk86a5psv985i8qmba30";
    };
  };
  vim-bracketed-paste = pkgs.vimUtils.buildVimPlugin {
    name = "vim-bracketed-paste";
    src = pkgs.fetchFromGitHub {
      owner = "ConradIrwin";
      repo = "vim-bracketed-paste";
      rev = "c4c639f3cacd1b874ed6f5f196fac772e089c932";
      sha256 = "1hhi7ab36iscv9l7i64qymckccnjs9pzv0ccnap9gj5xigwz6p9h";
    };
  };
  vim-buffet = pkgs.vimUtils.buildVimPlugin {
    name = "vim-buffet";
    src = pkgs.fetchFromGitHub {
      owner = "bagrat";
      repo = "vim-buffet";
      rev = "d4f90cc5b9ef613e6464990f204006d74f89978a";
      sha256 = "183yb722qh3pvsb3n7vvzqpw7jlv2kcixz34qn3k4bsqj41g8y5y";
    };
  };
  vim-crystalline = pkgs.vimUtils.buildVimPlugin {
    name = "vim-crystalline";
    src = pkgs.fetchFromGitHub {
      owner = "rbong";
      repo = "vim-crystalline";
      rev = "32698e3560ddb68bbb648fcfb677e9af45f70a79";
      sha256 = "0sssm39rlixd3hfqwa0x9y25jbdihdm9frmwrrfpvidipplafy0q";
    };
  };
  vim-one = pkgs.vimUtils.buildVimPlugin {
    name = "vim-one";
    src = pkgs.fetchFromGitHub {
      owner = "reedes";
      repo = "vim-one";
      rev = "366e33b1eb317b2ce2292e2869b31a7c1516c753";
      sha256 = "0kw63xc48cb4q291bmybmklybvr0hlfzdq010cr2xsi7xpqmg2z2";
    };
  };
  vim-pythonsense = pkgs.vimUtils.buildVimPlugin {
    name = "vim-pythonsense";
    src = pkgs.fetchFromGitHub {
      owner = "jeetsukumaran";
      repo = "vim-pythonsense";
      rev = "9200a57629c904ed2ab8c9b2e8c5649d311794ba";
      sha256 = "1m2qz3j05f3y99wjjcnkhbpj8j3hdsnwjc33skzldv5khspg011d";
    };
  };
  vim-textobj-entire = pkgs.vimUtils.buildVimPlugin {
    name = "vim-textobj-entire";
    src = pkgs.fetchFromGitHub {
      owner = "kana";
      repo = "vim-textobj-entire";
      rev = "64a856c9dff3425ed8a863b9ec0a21dbaee6fb3a";
      sha256 = "0kv0s85wbcxn9hrvml4hdzbpf49b1wwr3nk6gsz3p5rvfs6fbvmm";
    };
  };
  vim-textobj-line = pkgs.vimUtils.buildVimPlugin {
    name = "vim-textobj-line";
    src = pkgs.fetchFromGitHub {
      owner = "kana";
      repo = "vim-textobj-line";
      rev = "0a78169a33c7ea7718b9fa0fad63c11c04727291";
      sha256 = "0mppgcmb83wpvn33vadk0wq6w6pg9cq37818d1alk6ka0fdj7ack";
    };
  };
in
{
  name = "vim";
  vimrcConfig.beforePlugins = ''
    set nocompatible
    " Prevent vim-polyglot messing with random settings.
    let g:polyglot_disabled = ['sensible']
  '';
  vimrcConfig.customRC = builtins.readFile ./vimrc;
  vimrcConfig.packages.pkgs = with pkgs.vimPlugins; {
    start = [
      # Tim Pope
      vim-commentary
      vim-eunuch
      vim-fugitive
      vim-repeat
      vim-scriptease
      vim-sensible
      vim-speeddating
      vim-surround
      # Appearance
      gruvbox-community
      vim-buffet
      vim-crystalline
      vim-polyglot
      # Text objects
      vim-angry
      vim-pythonsense
      vim-textobj-comment
      vim-textobj-entire
      vim-textobj-line
      vim-textobj-user
      # Keybinds
      conflict-marker-vim
      ctrlp
      vim-table-mode
      # Behaviour
      editorconfig-vim
      pear-tree
      vim-bracketed-paste
      vim-gitgutter
      vim-one
      vim-rooter
    ];
  };
}
