require 'rubygems'
require 'gosu'
require 'player'
require 'ball'

class MyGame < Gosu::Window
  def initialize
    super(2000, 1700, false)
    @player1 = Player.new(self)
    @balls = 1.times.map {Ball.new(self)}
    @running = true
    @font = Gosu::Font.new(self, Gosu::default_font_name, 90)
    @background = Gosu::Image.new(self, "images/background.png", true)
    @score = 0
    @highest_score = @score
    @message = ""
  
  end
  
  def update
    if @running
      @score = @score + 1
      
      if @score%100 == 0
        5.times do
          @balls << Ball.new(self)
        end
      end
      
      if button_down? Gosu::Button::KbLeft
        @player1.move_left
      end
    
      if button_down? Gosu::Button::KbRight
        @player1.move_right
      end
    
      if button_down? Gosu::Button::KbUp
        @player1.move_up
      end
    
      if button_down? Gosu::Button::KbDown
        @player1.move_down
      end
    
      @balls.each {|ball| ball.update}
    
      if @player1.hit_by? @balls
        stop_game!
        if @score > @highest_score
          @message = "New High Score!"
          @highest_score = @score
        end
      end
      
    else
      if button_down? Gosu::Button::KbEscape
        restart_game
      end
    end
  end
  
  def draw
    @font.draw("The score is: #{@score}",20,20,5)
    @font.draw("The high score is: #{@highest_score}",20,120,5)
    @font.draw(@message,700,750,10)
    @background.draw(0,0,1)
    @player1.draw
    @balls.each {|ball| ball.draw}
  end
  
  def stop_game!
    @running = false
  end
  
  def restart_game
    @message = ""
    @score = 0
    @balls = 1.times.map {Ball.new(self)}
    @running = true
    @balls.each {|ball| ball.reset!}
  end
  
end

game = MyGame.new
game.show
