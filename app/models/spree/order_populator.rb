module Spree
  class OrderPopulator
    attr_accessor :order, :currency
    attr_reader :errors

    def initialize(order, currency)
      @order = order
      @currency = currency
      @errors = ActiveModel::Errors.new(self)
    end

    #
    # Parameters can be passed using the following possible parameter configurations:
    #
    # * Single variant/quantity pairing
    # +:variants => { variant_id => quantity }+
    #
    # * Multiple products at once
    # +:products => { product_id => variant_id, product_id => variant_id }, :quantity => quantity+
    def populate(from_hash)
# 17/10/13 DH: Seeing how we can add the custom BSC pricing to the cart
debugger
      
      # 17/10/13 DH: Store the dynamic BSC price for addition at 'OrderContents.add_to_line_item()' stage.
      if from_hash[:price]
        @order.contents.bscDynamicPrice = BigDecimal.new(from_hash[:price])
      end
    
      from_hash[:products].each do |product_id,variant_id|
      
        # 17/10/13 DH: If the hash contains a 'price' then set the variant's price
        #              However this permanantly changes the variant's price so effects later use! 
        #if from_hash[:price]
        #  Spree::Variant.find(variant_id).default_price =  Spree::Price.new(:amount => from_hash[:price], :currency => currency)
        #end
      
        attempt_cart_add(variant_id, from_hash[:quantity])
      end if from_hash[:products]

      from_hash[:variants].each do |variant_id, quantity|
      
        attempt_cart_add(variant_id, quantity)
      end if from_hash[:variants]

      valid?
    end

    def valid?
      errors.empty?
    end

    private

    def attempt_cart_add(variant_id, quantity)
      quantity = quantity.to_i
      # 2,147,483,647 is crazy.
      # See issue #2695.
      if quantity > 2_147_483_647
        errors.add(:base, Spree.t(:please_enter_reasonable_quantity, :scope => :order_populator))
        return false
      end

      variant = Spree::Variant.find(variant_id)
      if quantity > 0

        line_item = @order.contents.add(variant, quantity, currency)
        unless line_item.valid?
          errors.add(:base, line_item.errors.messages.values.join(" "))
          return false
        end
      end
    end
  end
end