(function() {
  var item;

  jQuery(function() {
    Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'));
    return item.setupForm();
  });

  item = {
    setupForm: function() {
      return $('#new_item').submit(function() {
        $('input[type=submit]').attr('disabled', true);
        Stripe.bankAccount.createToken($('#new_item'), item.handleStripeResponse);
        return false;
      });
    },
    handleStripeResponse: function(status, response) {
      if (status === 200) {
        $('#new_item').append($('<input type="hidden" name="stripeToken" />').val(response.id));
        return $('#new_item')[0].submit();
      } else {
        $('#stripe_error').text(response.error.message).show();
        return $('input[type=submit]').attr('disabled', false);
      }
    }
  };

}).call(this);
