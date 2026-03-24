const stripe = require('stripe')(process.env.STRIPE_SECRET_KEY);

exports.handler = async (event) => {
  const headers = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Headers': 'Content-Type',
    'Content-Type': 'application/json',
  };

  if (event.httpMethod === 'OPTIONS') return { statusCode: 200, headers, body: '' };
  if (event.httpMethod !== 'POST') return { statusCode: 405, headers, body: JSON.stringify({ error: 'Method not allowed' }) };

  try {
    const { plan, email, userId } = JSON.parse(event.body);
    const priceId = plan === 'teams' ? process.env.STRIPE_TEAMS_PRICE_ID : process.env.STRIPE_PRO_PRICE_ID;

    if (!priceId) throw new Error('Price ID not configured for plan: ' + plan);

    const origin = event.headers.origin || event.headers.referer?.replace(/\/[^/]*$/, '') || 'https://emrtrainerapp.com';

    const session = await stripe.checkout.sessions.create({
      mode: 'subscription',
      payment_method_types: ['card'],
      customer_email: email,
      client_reference_id: userId,
      line_items: [{ price: priceId, quantity: 1 }],
      success_url: `${origin}/?payment=success&plan=${plan}`,
      cancel_url: `${origin}/?payment=cancelled`,
      metadata: { plan, userId },
    });

    return { statusCode: 200, headers, body: JSON.stringify({ url: session.url }) };
  } catch (err) {
    return { statusCode: 500, headers, body: JSON.stringify({ error: err.message }) };
  }
};
