# 10/10/13 DH: Let's Monkey-patch the baby...it's a Ruby thing... :)
Spree::AppConfiguration.class_eval do

  #preference :use_store_credit_minimum, :float, :default => 0.0

  preference :pencil_pleat_multiple, :float
  preference :deep_pencil_pleat_multiple, :float
  preference :double_pleat_multiple, :float
  preference :triple_pleat_multiple, :float
  preference :eyelet_pleat_multiple, :float
  
  # Following numbers are in 'cm'
  preference :returns_addition, :integer
  preference :side_hems_addition, :integer
  preference :turnings_addition, :integer
  
  preference :fabric_width, :integer
  
  # Following numbers are in '£/m'
  preference :cotton_lining, :float
  preference :cotton_lining_labour, :integer
  
  preference :blackout_lining, :float
  preference :blackout_lining_labour, :integer
  
  preference :thermal_lining, :float
  preference :thermal_lining_labour, :integer
  
  preference :curtain_maker_email, :string
  
end

# These values get automatically put into the 'spree_preferences' table in the DB on startup...nice!
# (along with those from 'spree.rb' and the '/admin' interface)

Spree::Config[:pencil_pleat_multiple]      = 2.5
Spree::Config[:deep_pencil_pleat_multiple] = 2.5
Spree::Config[:double_pleat_multiple]      = 2.75
Spree::Config[:triple_pleat_multiple]      = 2.75
Spree::Config[:eyelet_pleat_multiple]      = 2

# Following numbers are in 'cm'
Spree::Config[:returns_addition]   = 12
Spree::Config[:side_hems_addition] = 20
Spree::Config[:turnings_addition]  = 20

Spree::Config[:fabric_width] = 137

# Following numbers are in '£/m'
Spree::Config[:cotton_lining]   = 4
Spree::Config[:blackout_lining] = 4.8
Spree::Config[:thermal_lining]  = 4.5

Spree::Config[:cotton_lining_labour]   = 4
Spree::Config[:blackout_lining_labour] = 4
Spree::Config[:thermal_lining_labour]  = 4

#Spree::Config[:mails_from] = "sales@bespokesilkcurtains.com"
Spree::Config[:curtain_maker_email] = "doughazell@gmail.com"
