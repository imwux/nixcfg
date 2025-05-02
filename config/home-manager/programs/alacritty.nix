{ ... }:
{
    programs.alacritty.settings = {
        window = {
            padding = {
                x = 6;
                y = 5;
            };
            dynamic_padding = false;
            opacity = 0.75;
        };
        cursor = {
            style.shape = "Beam";
            unfocused_hollow = true;
        };
        terminal.osc52 = "CopyPaste";
    };
}
