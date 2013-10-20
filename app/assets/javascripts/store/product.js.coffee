# "$ ->" same as "jQuery ->" since CoffeeScript using jQuery...you beauty...feel the Javascript leverage...
$ ->
  # Use this to store values in the DOM
  exports = this
  
  Spree.addImageHandlers = ->
    thumbnails = ($ '#product-images ul.thumbnails')
    ($ '#main-image').data 'selectedThumb', ($ '#main-image img').attr('src')
    thumbnails.find('li').eq(0).addClass 'selected'
    thumbnails.find('a').on 'click', (event) ->
      ($ '#main-image').data 'selectedThumb', ($ event.currentTarget).attr('href')
      ($ '#main-image').data 'selectedThumbId', ($ event.currentTarget).parent().attr('id')
      ($ this).mouseout ->
        thumbnails.find('li').removeClass 'selected'
        ($ event.currentTarget).parent('li').addClass 'selected'
      false

    thumbnails.find('li').on 'mouseenter', (event) ->
      ($ '#main-image img').attr 'src', ($ event.currentTarget).find('a').attr('href')

    thumbnails.find('li').on 'mouseleave', (event) ->
      ($ '#main-image img').attr 'src', ($ '#main-image').data('selectedThumb')

  Spree.showVariantImages = (variantId) ->
    ($ 'li.vtmb').hide()
    ($ 'li.tmb-' + variantId).show()
    currentThumb = ($ '#' + ($ '#main-image').data('selectedThumbId'))
    if not currentThumb.hasClass('vtmb-' + variantId)
      thumb = ($ ($ 'ul.thumbnails li:visible.vtmb').eq(0))
      thumb = ($ ($ 'ul.thumbnails li:visible').eq(0)) unless thumb.length > 0
      newImg = thumb.find('a').attr('href')
      ($ 'ul.thumbnails li').removeClass 'selected'
      thumb.addClass 'selected'
      ($ '#main-image img').attr 'src', newImg
      ($ '#main-image').data 'selectedThumb', newImg
      ($ '#main-image').data 'selectedThumbId', thumb.attr('id')

  Spree.updateVariantPrice = (variant) ->
    variantPrice = variant.data('price')
    ($ '.price.selling').text(variantPrice) if variantPrice
        
  radios = ($ '#product-variants input[type="radio"]')

  if radios.length > 0
    Spree.showVariantImages ($ '#product-variants input[type="radio"]').eq(0).attr('value')
    Spree.updateVariantPrice radios.first()

  Spree.addImageHandlers()
    
  ###
  =================== BSC dynamic pricing =====================
  ###

  # ------------------ Params (from initializer file) stored in web page via 'data-' attribute and used by jQuery --------------
  # Following numbers are in 'cm'
  returns_addition   = ($ '#bsc-pricing').data('returns-addition')
  side_hems_addition = ($ '#bsc-pricing').data('side-hems-addition')
  turnings_addition  = ($ '#bsc-pricing').data('turnings-addition')

  fabric_width = ($ '#bsc-pricing').data('fabric-width')

  # Following numbers are in '£/m'  
  cotton_lining   = ($ '#bsc-pricing').data('cotton-lining')
  blackout_lining = ($ '#bsc-pricing').data('blackout-lining')
  thermal_lining  = ($ '#bsc-pricing').data('thermal-lining')    

  cotton_lining_labour   = ($ '#bsc-pricing').data('cotton-lining-labour')
  blackout_lining_labour = ($ '#bsc-pricing').data('blackout-lining-labour')
  thermal_lining_labour  = ($ '#bsc-pricing').data('thermal-lining-labour')   
  # ----------------------------------------------------------------------------------------------------------------------------- 

  # These are the values assigned when the 'width' + 'drop' fields are assigned (so needs to be declared above the function definition)
  number_of_widths = 0
  required_fabric_len = 0
  price = 0

  Spree.getCurrentMultiple = ->
    current_heading = ($ '#product-variants input[type="radio"]:checked').data('heading')
    
    # Replace the whitespace between the heading words, in the variant list, with hyphens, in order to access the stored data
    hyphened_heading = current_heading.replace(/\ /g, '-')
    hyphened_heading += "-multiple"
    # Implicit return of last value
    current_multiple_val = ($ '#bsc-pricing').data(hyphened_heading)    
    # ---

  Spree.calcNumberOfWidths = (width) ->
    width += returns_addition
    
    multiple = Spree.getCurrentMultiple()
    
    required_width = width * multiple
    required_width += side_hems_addition
    # We always need to round up, NOT TO NEAREST INT, so 2.1 needs to be 3 not 2!
    number_of_widths = Math.ceil(required_width / fabric_width)
    # ---
  
  Spree.calcPrice = (drop) ->
    cutting_len = drop + turnings_addition
    # Convert to meters to calc price based on "£/m"
    required_fabric_len = cutting_len * number_of_widths / 100

    price_string = ($ '#product-variants input[type="radio"]:checked').data('price')
    # Remove the preceding '£' sign
    price_per_meter = price_string.replace(/£/g, ' ')

    # Multiply by 100 to convert to pence, round to nearest penny, then convert back to pounds by dividing by 100, simples...
    price = (Math.round(required_fabric_len * price_per_meter * 100)) / 100
    # ---
    
  # ========================================= 'jQuery' DOM event binding in CoffeeScript ========================================
  #                                          |------------------------------------------|
  #                                              (A little bit of ASCII-art for you)
  #                                                   Apparantly autistic people, 
  #                                                     like to line things up.
  #
  #                                                     "Welcome to the Matrix"
  #                                           The mental projection of your digital self.
  #
  #                                                               :-)
  #
  # 8/10/13 DH: I feel I'm finally on home ground...ye haaa! :) That's only taken me 8 years since cutting the bootloader code...

  # ------------------ Width ------------------
  $(document).on('blur', '#width', ( ->
    width = (Number) @value
    Spree.calcNumberOfWidths (width)
    
    ($ '#price-text').text(number_of_widths)
  ))
  # ---
  
  # ----------------- Drop ------------------  
  $(document).on('blur', '#drop', ( ->
    drop = (Number) @value
    Spree.calcPrice (drop)

    ($ '#price-text').text("£" + price)
  ))
  # ---

  # ----------------- Lining ------------------    
  $(document).on('click', '#lining', ( ->
    lining_id = @value
    lining = ($ '#lining option:selected').data('type')

    ($ '#price-text').text(lining)
  ))
  # ---

  # ----------------- Heading ------------------      
  radios.click (event) ->
    # ----- Orig Spree product display -----
    Spree.showVariantImages @value
    Spree.updateVariantPrice ($ this)
    # --------------------------------------
    
    width = (Number) ($ '#width').val()
    drop  = (Number) ($ '#drop').val()
    Spree.calcNumberOfWidths ( width )
    Spree.calcPrice ( drop )
    
    ($ '#price-text').text("£" + price)
    # ---

  # ----------------- Submit ------------------    
  $(document).on('click', '#add-to-cart-button', ( ->
    # Send the dynamic price back to the server via '#price' <input> tag to the <form>
    ($ '#price').val(price)
    ($ '#price-text').text("Submit")
  ))
  # ---

  
  # ----------------- On-load ------------------    
  ($ '#price-text').text(($ '#lining option:selected').data('type'))
  
#    ($ '#price-text').text(jQuery.type(price_per_meter))
#    ($ '#price-text').text(($ '#product-variants input[type="radio"]:checked').attr('data-price')) 
#    ($ '#price-text').text(($ '#product-variants input[type="radio"]:checked').data('price'))    
