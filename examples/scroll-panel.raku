use Raylib::Bindings;
use Raygui::Bindings;
use NativeCall;

constant SCROLLBAR_LEFT_SIDE = 0;
constant SCROLLBAR_RIGHT_SIDE = 1;

sub draw-style-edit-controls() {
    # ScrollPanel style controls
    gui-group-box(Rectangle.init(550e0, 170e0, 220e0, 205e0), "SCROLLBAR STYLE");
    
    my $style-array = CArray[int32].new;
    $style-array[0] = gui-get-style(SCROLLBAR, BORDER_WIDTH);
    gui-label(Rectangle.init(555e0, 195e0, 110e0, 10e0), "BORDER_WIDTH");
    gui-spinner(Rectangle.init(670e0, 190e0, 90e0, 20e0), Str, $style-array, 0, 6, False);
    gui-set-style(SCROLLBAR, BORDER_WIDTH, $style-array[0]);
    
    $style-array[0] = gui-get-style(SCROLLBAR, ARROWS_SIZE);
    gui-label(Rectangle.init(555e0, 220e0, 110e0, 10e0), "ARROWS_SIZE");
    gui-spinner(Rectangle.init(670e0, 215e0, 90e0, 20e0), Str, $style-array, 4, 14, False);
    gui-set-style(SCROLLBAR, ARROWS_SIZE, $style-array[0]);
    
    my bool $scroll-bar-arrows = so gui-get-style(SCROLLBAR, ARROWS_VISIBLE);
    gui-check-box(Rectangle.init(565e0, 280e0, 20e0, 20e0), "ARROWS_VISIBLE", $scroll-bar-arrows);
    gui-set-style(SCROLLBAR, ARROWS_VISIBLE, $scroll-bar-arrows.Int);
    
    $style-array[0] = gui-get-style(SCROLLBAR, SLIDER_PADDING);
    gui-label(Rectangle.init(555e0, 325e0, 110e0, 10e0), "SLIDER_PADDING");
    gui-spinner(Rectangle.init(670e0, 320e0, 90e0, 20e0), Str, $style-array, 0, 14, False);
    gui-set-style(SCROLLBAR, SLIDER_PADDING, $style-array[0]);
    
    $style-array[0] = gui-get-style(SCROLLBAR, SLIDER_WIDTH);
    gui-label(Rectangle.init(555e0, 350e0, 110e0, 10e0), "SLIDER_WIDTH");
    gui-spinner(Rectangle.init(670e0, 345e0, 90e0, 20e0), Str, $style-array, 2, 100, False);
    gui-set-style(SCROLLBAR, SLIDER_WIDTH, $style-array[0]);
    
    my $text = (gui-get-style(LISTVIEW, SCROLLBAR_SIDE) == SCROLLBAR_LEFT_SIDE) ?? "SCROLLBAR: LEFT" !! "SCROLLBAR: RIGHT";
    my bool $toggle-scroll-bar-side = so gui-get-style(LISTVIEW, SCROLLBAR_SIDE);
    gui-toggle(Rectangle.init(560e0, 110e0, 200e0, 35e0), $text, $toggle-scroll-bar-side);
    gui-set-style(LISTVIEW, SCROLLBAR_SIDE, $toggle-scroll-bar-side.Int);
    
    # ScrollBar style controls
    gui-group-box(Rectangle.init(550e0, 20e0, 220e0, 135e0), "SCROLLPANEL STYLE");
    
    $style-array[0] = gui-get-style(LISTVIEW, SCROLLBAR_WIDTH);
    gui-label(Rectangle.init(555e0, 35e0, 110e0, 10e0), "SCROLLBAR_WIDTH");
    gui-spinner(Rectangle.init(670e0, 30e0, 90e0, 20e0), Str, $style-array, 6, 30, False);
    gui-set-style(LISTVIEW, SCROLLBAR_WIDTH, $style-array[0]);
    
    $style-array[0] = gui-get-style(DEFAULT, BORDER_WIDTH);
    gui-label(Rectangle.init(555e0, 60e0, 110e0, 10e0), "BORDER_WIDTH");
    gui-spinner(Rectangle.init(670e0, 55e0, 90e0, 20e0), Str, $style-array, 0, 20, False);
    gui-set-style(DEFAULT, BORDER_WIDTH, $style-array[0]);
}

# Program main entry point
constant $screen-width = 800;
constant $screen-height = 450;

init-window($screen-width, $screen-height, "raygui - GuiScrollPanel()");

my $panel-rec = Rectangle.init(20e0, 40e0, 200e0, 150e0);
my $panel-content-rec = Rectangle.init(0e0, 0e0, 340e0, 340e0);
my $panel-view = Rectangle.init(0e0, 0e0, 0e0, 0e0);
my $panel-scroll = Vector2.init(99e0, -20e0);
my $mouse-cell = Vector2.init(0e0, 0e0);

my bool $show-content-area = True;

my $white = init-raywhite;
my $red = init-red;

set-target-fps(60);

# Main game loop
while !window-should-close {
    # Update
    # TODO: Implement required update logic
    
    # Draw
    begin-drawing;
        clear-background($white);
        
        my $scroll-text = sprintf("[%.1f, %.1f]", $panel-scroll.x, $panel-scroll.y);
        draw-text($scroll-text, 4, 4, 20, $red);
        
        gui-scroll-panel($panel-rec, Str, $panel-content-rec, $panel-scroll, $panel-view);
        
        begin-scissor-mode(
            $panel-view.x.Int, 
            $panel-view.y.Int, 
            $panel-view.width.Int, 
            $panel-view.height.Int
        );
            gui-grid(
                Rectangle.init(
                    $panel-rec.x + $panel-scroll.x, 
                    $panel-rec.y + $panel-scroll.y, 
                    $panel-content-rec.width, 
                    $panel-content-rec.height
                ), 
                Str, 
                16e0, 
                3, 
                $mouse-cell
            );
        end-scissor-mode;
        
        if $show-content-area {
            draw-rectangle(
                ($panel-rec.x + $panel-scroll.x).Int, 
                ($panel-rec.y + $panel-scroll.y).Int, 
                $panel-content-rec.width.Int, 
                $panel-content-rec.height.Int, 
                fade($red, 0.1e0)
            );
        }
        
        draw-style-edit-controls;
        
        gui-check-box(
            Rectangle.init(565e0, 80e0, 20e0, 20e0), 
            "SHOW CONTENT AREA", 
            $show-content-area
        );
        
        my num32 $width = $panel-content-rec.width;
        my $width-text = sprintf("%d", $width.Int);
        gui-slider-bar(
            Rectangle.init(590e0, 385e0, 145e0, 15e0), 
            "WIDTH", 
            $width-text, 
            $width, 
            1e0, 
            600e0
        );
        $panel-content-rec.width = $width;
        
        my num32 $height = $panel-content-rec.height;
        my $height-text = sprintf("%d", $height.Int);
        gui-slider-bar(
            Rectangle.init(590e0, 410e0, 145e0, 15e0), 
            "HEIGHT", 
            $height-text, 
            $height, 
            1e0, 
            400e0
        );
        $panel-content-rec.height = $height;
        
    end-drawing;
}

# De-Initialization
close-window;
