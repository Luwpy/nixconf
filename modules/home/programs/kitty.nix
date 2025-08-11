{
  programs.kitty = {
    enable = true;
    keybindings = {
      "ctrl+shift+tab" = "new_tab";
      "ctrl+j" = ''kitten pass_keys.py bottom ctrl+j'';
      "ctrl+k" = ''kitten pass_keys.py top    ctrl+k'';
      "ctrl+h" = ''kitten pass_keys.py left   ctrl+h'';
      "ctrl+l" = ''kitten pass_keys.py right  ctrl+l'';
    };
    settings = {
      scrollback_lines = 10000;
      initial_window_width = 1200;
      initial_window_height = 600;
      update_check_interval = 0;
      enable_audio_bell = false;
      confirm_os_window_close = "0";
      remember_window_size = "no";
      disable_ligatures = "never";
      url_style = "curly";
      copy_on_select = "clipboard";
      cursor_shape = "Underline";
      cursor_underline_thickness = 3;
      cursor_trail = 3;
      cursor_trail_decay = "0.1 0.4";
      window_padding_width = 10;
      open_url_with = "default";
      allow_remote_control = "yes";
      listen_on = "unix:/tmp/mykitty";
    };
  };
}
