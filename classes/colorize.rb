class String

    def to_red;          colorize(self, "\e[1m\e[31m");  end
    def to_dark_red;     colorize(self, "\e[31m");       end
    def to_green;        colorize(self, "\e[1m\e[32m");  end
    def to_dark_green;   colorize(self, "\e[32m");       end
    def to_yellow;       colorize(self, "\e[1m\e[33m");  end
    def to_dark_yellow;  colorize(self, "\e[33m");       end
    def to_blue;         colorize(self, "\e[1m\e[34m");  end
    def to_dark_blue;    colorize(self, "\e[34m");       end
    def to_purple;       colorize(self, "\e[1m\e[35m");  end

    def to_def;          colorize(self, "\e[1m");  end    
    def to_bold;         colorize(self, "\e[1m");  end
    def to_blink;        colorize(self, "\e[5m");  end
    
    def colorize(text, color_code)  "#{color_code}#{text}\e[0m" end

end