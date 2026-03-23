const stripe = require('stripe')(process.env.STRIPE_SECRET_KEY);
const { createClient } = require('@supabase/supabase-js');

exports.handler = async (event) => {
  const sig = event.headers['stripe-signature'];
  let stripeEvent;

  try {
    stripeEvent = stripe.webhooks.constructEvent(
      event.body,
      sig,
      process.env.STRIPE_WEBHOOK_SECRET
    );
  } catch (err) {
    return { statusCode: 400, body: `Webhook error: ${err.message}` };
  }

  const supa = createClient(
    process.env.SUPABASE_URL || 'https://rrfcukkvdsraukybkxzc.supabase.co',
    process.env.SUPABASE_SERVICE_ROLE_KEY
  );

  if (stripeEvent.type === 'checkout.session.completed') {
    const session = stripeEvent.data.object;
    const userId = session.client_reference_id;
    const plan = session.metadata?.plan || 'pro';

    if (userId) {
      await supa.from('profiles').update({
        is_premium: true,
        plan,
        stripe_customer_id: session.customer,
        stripe_subscription_id: session.subscription,
      }).eq('id', userId);
    }
  }

  if (stripeEvent.type === 'customer.subscription.deleted') {
    const sub = stripeEvent.data.object;
    await supa.from('profiles')
      .update({ is_premium: false, plan: 'free' })
      .eq('stripe_subscription_id', sub.id);
  }

  return { statusCode: 200, body: JSON.stringify({ received: true }) };
};
