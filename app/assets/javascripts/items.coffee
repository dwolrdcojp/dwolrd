jQuery -> 
    Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'))
    item.setupForm()

item =
  setupForm: ->
    $('#new_item').submit ->
      $('input[type=submit]').attr('disabled', true)
      Stripe.bankAccount.createToken($('#new_item'), item.handleStripeResponse)
      false

  handleStripeResponse: (status, response) ->
    if status == 200
      $('#new_item').append($('<input type="hidden" name="stripeToken" />').val(response.id))
      $('#new_item')[0].submit()
    else
      $('#stripe_error').text(response.error.message).show()
      $('input[type=submit]').attr('disabled', false)