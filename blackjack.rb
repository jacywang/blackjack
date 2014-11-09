require "pry"
def initialize_shoe
  deck = []
  4.times do
    (2..10).each { |n| deck << n }
    deck << "Jack" << "Queen" << "King" << "Ace" 
  end
  shoe = deck
  [1, 2, 3].sample.times { |n| shoe += deck}
  shoe.shuffle!
end

def get_card(shoe)
  shoe.pop
end

def display_cards(player_cards, dealer_cards, player_stay = false)
  if player_stay
    puts "Dealer's cards: #{dealer_cards}"
  else
    puts "Dealer's cards: #{["*"] + dealer_cards[1..dealer_cards.length]}"
  end
  puts "#{PLAYER_NAME}'s cards: #{player_cards}"
end

def card_to_num_except_ace(card)
  card_value_table = { 2 => 2, 3 => 3, 4 => 4, 5 => 5, 6 => 6, 7 => 7, 8 => 8, 9 =>9,
  10 => 10, "Jack" => 10, "Queen" => 10, "King" => 10 }
  card_value_table[card]
end

def calculate_ace_sum(num_of_ace, sum_without_ace)
  if num_of_ace == 0
    0
  else
    (sum_without_ace + num_of_ace + 10 > 21) ? num_of_ace : (num_of_ace + 10)
  end
end

def calculate_cards_total(cards)
  sum_without_ace = cards.select { |card| card != 'Ace'}.inject(0) { |sum, card| sum + card_to_num_except_ace(card) }
  num_of_ace = cards.count("Ace")
  cards_sum = sum_without_ace + calculate_ace_sum(num_of_ace, sum_without_ace)
end

def player_take_action
  begin 
    puts "Choose one of the following,"
    puts "1. Hit 2. Stay"
    player_choice = gets.chomp
  end until ['1', '2'].include?(player_choice)
  if player_choice == '1'
    puts "#{PLAYER_NAME} chose to hit!"
    return "Hit"
  end
  if player_choice == '2'  
    puts "#{PLAYER_NAME} chose to stay!"
    return "Stay"
  end
end

def player_hit_21_or_busted?(cards)
  player_cards_sum = calculate_cards_total(player_cards)
  if player_cards_sum == 21
    puts "#{PLAYER_NAME} has 21 and won!"
    return true
  end
  if player_cards_sum > 21
    puts "#{PLAYER_NAME} busted and lost!" 
    return true
  end
end

def check_winner(player_cards, dealer_cards)
  player_cards_sum = calculate_cards_total(player_cards)
  dealer_cards_sum = calculate_cards_total(dealer_cards)
  if dealer_cards_sum == 21
    puts "Dealer hit 21! Dealer won!"
    "Dealer"
  elsif dealer_cards_sum > 21
    puts "Dealer busted! #{PLAYER_NAME} won!"
    "#{PLAYER_NAME}"
  elsif dealer_cards_sum >= 17
    if player_cards_sum == dealer_cards_sum
      puts "It's a tie!"
      "Tie"
    elsif player_cards_sum > dealer_cards_sum
      puts "#{PLAYER_NAME} won!"
      "PLAYER_NAME"
    else
      puts "Dealer won!"
      "Dealer"
    end
  end
end

puts "What's your name?"
PLAYER_NAME = gets.chomp
puts "Welcome to the BLACKJACK game, #{PLAYER_NAME}!"

begin 
  shoe = initialize_shoe

  player_cards = [get_card(shoe), get_card(shoe)]
  dealer_cards = [get_card(shoe), get_card(shoe)]

  display_cards(player_cards, dealer_cards)

  if calculate_cards_total(player_cards) == 21
    puts "#{PLAYER_NAME} won!"
  else 
    begin 
      player_choice = player_take_action
      player_cards << get_card(shoe) if player_choice == "Hit"
      display_cards(player_cards, dealer_cards) if player_choice == "Hit"
    end until player_choice == "Stay" || player_hit_21_or_busted?(player_cards)
    
    if player_choice == "Stay"
      display_cards(player_cards,dealer_cards,true)
      result = check_winner(player_cards, dealer_cards)
      if !result
        puts "It's dealer's turn!"
        begin
          puts "Dealer hit!"
          dealer_cards << get_card(shoe)
          display_cards(player_cards, dealer_cards, true) 
        end until check_winner(player_cards, dealer_cards)
      end 
    end
  end

  puts "Play again? Y or N"
  begin 
    play_again = gets.chomp.upcase
  end until ["Y", "N"].include?(play_again)
end until play_again == "N"
