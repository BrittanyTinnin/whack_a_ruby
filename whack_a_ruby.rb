require 'gosu'

class WhackARuby < Gosu::Window
  def initialize()
    super(800, 600)
    self.caption = 'Whack the Ruby!'
    @image = Gosu::Image.new('pictures/ruby.png')
    @x = 200
    @y = 200
    @width = 50
    @height = 43
    @velocity_x = 3
    @velocity_y = 3
    @visible = 0
    @hammer_image = Gosu::Image.new('pictures/hammer.png')
    @hit = 0
    @font = Gosu::Font.new(30)
    @score = 0
    @playing = true
    @start_time = 0
  end

  def button_down(id)
    if @playing
      if (id == Gosu::MsLeft)
        if Gosu.distance(mouse_x, mouse_y, @x, @y) < 50 && @visible >= 0
          @hit = 1
          @score += 5
        else
          @hit = -1
          @score -= 1
        end
      end
    else
      if (id == Gosu::KbSpace)
        @playing = true
        @visible = -10
        @start_time = Gosu.milliseconds
        @score = 0
      end
    end
  end

  def update
    if @playing
      @x += @velocity_x
      @y += @velocity_y
      @velocity_x *= -1 if @x + @width/2 > 800 || @x - @width/2 < 0
      @velocity_y *= -1 if @y + @height/2 > 600 || @y - @height < 0
      @visible -= 1
      @visible = 80 if @visible < -10 && rand < 0.01
      @time_left = (100 - ((Gosu.milliseconds - @start_time)/ 1000))
      @playing = false if @time_left == 0
    end
  end

  def draw
    if @visible > 0
      @image.draw(@x - @width/2, @y - @height/2, 1)
    end
    @hammer_image.draw(mouse_x - 40, mouse_y - 10, 1)
    if @hit == 0
      c = Gosu::Color::NONE
    elsif @hit == 1
      c = Gosu::Color::GREEN
    elsif @hit == -1
      c = Gosu::Color::RED
    end
    draw_quad(0, 0, c, 800, 0, c, 800, 600, c, 0, 600, c)
    @hit = 0
    @font.draw_text(@time_left.to_s, 20, 20, 2)
    @font.draw_text(@score.to_s, 700, 20, 2)
    unless @playing
      @font.draw_text('Game Over', 300, 300, 3)
      @font.draw_text('Press the Space Bar to Play Again', 175, 350, 3)
      @visible = 20
    end
  end


end

window = WhackARuby.new
window.show()
