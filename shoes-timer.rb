## Please note:
# Only works with Shoes 3

module Shoes::Types
  def centr
    left=(self.parent.width-self.style[:width])/2
    self.move(left,self.top)
  end
end

Shoes.app width: 1000, height: 600 do

  MAX_TIME = 60 * 5
  @seconds = MAX_TIME
  @paused = true


  def location_color(value)
    value = 0.02 if value < 0.02
      
    value = 0.99 if value == 1

    value = (511 * value).floor
    difference = (255 - value).abs

    if value < 255
      value = value + (difference * 2);
    else
      value = value - (difference * 2);
    end

    actualGreenValue = 0;
    actualRedValue = 0

    if (value < 255)
        actualGreenValue = 255;
        actualRedValue = Math.sqrt(value) * 16;
        actualRedValue = (actualRedValue).round;
    else
        actualRedValue = 255;
        value = value - 255;
        actualGreenValue = 256 - (value * value / 255)
        actualGreenValue = actualGreenValue.round
    end
    "#" + actualRedValue.to_s(16) + actualGreenValue.to_s(16) + "00"
  end


  def stroke_color
    if @paused
      gray
    else
      location_color(@seconds.to_f / MAX_TIME)
    end
  end

  def display_time
    @display.clear do
      background black

      banner("%02d:%02d" % [
        @seconds / 60 % 60,
        @seconds % 60
      ], stroke: stroke_color, 
      size: 100,
      align: "center")
    end.centr
  end

  def start_button
    button "Start", width: '100%' do 
      toggle_timer
    end
  end

  def pause_button
    button "Pause", width: '100%' do
      toggle_timer
    end
  end

  def hide_show_buttons
    if @paused
      @pause_button.hide
      @start_button.show
    else
      @pause_button.show
      @start_button.hide
    end
  end

  def toggle_timer
    @paused = !@paused
    hide_show_buttons
    display_time
  end

  @window = stack width: 1000, height: 600

  @window.append do
    flow width: 1000, height: 300 do
      image 'ruby_yyc_square.png', width: 300, margin_left: 50
      image 'lightning-talks.jpg', width: 600
    end
  end

  @window.append do
    flow do
      @display = stack(width: 1000).centr
      display_time
    end
  end

  @window.append do
    @start_button = start_button
    @pause_button = pause_button
  end
  
  @window.append do
    @reset_button = button "Reset", width: '100%' do
      @paused = true if !@paused

      hide_show_buttons

      @seconds = MAX_TIME
      display_time
    end
  end

  @window

  animate(1) do
    @seconds -= 1 unless @paused

    display_time
    if @seconds == 0
      @paused = true
      @seconds = MAX_TIME
      hide_show_buttons
      alert("Time's Up!")
    end

  end

end