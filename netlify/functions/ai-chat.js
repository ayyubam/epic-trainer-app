const { createClient } = require('@supabase/supabase-js');

const FREE_DAILY_LIMIT = 3;
const FREE_TRIAL_DAYS = 21;

exports.handler = async function (event, context) {
  const corsHeaders = {
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Headers": "Content-Type",
  };

  if (event.httpMethod === "OPTIONS") return { statusCode: 200, headers: corsHeaders, body: "" };
  if (event.httpMethod !== "POST") return { statusCode: 405, headers: { ...corsHeaders, "Content-Type": "application/json" }, body: JSON.stringify({ error: "Method not allowed" }) };

  const apiKey = process.env.ANTHROPIC_API_KEY;
  if (!apiKey) return { statusCode: 500, headers: { ...corsHeaders, "Content-Type": "application/json" }, body: JSON.stringify({ error: "API key not configured" }) };

  try {
    const body = JSON.parse(event.body);
    const userId = body.userId;

    // Check free tier limits
    if (userId) {
      const supa = createClient(
        process.env.SUPABASE_URL || 'https://rrfcukkvdsraukybkxzc.supabase.co',
        process.env.SUPABASE_SERVICE_ROLE_KEY
      );
      const { data: profile } = await supa.from('profiles').select('is_premium, ai_questions_today, ai_questions_date, created_at').eq('id', userId).single();

      if (profile && !profile.is_premium) {
        const today = new Date().toISOString().split('T')[0];
        const accountAgeDays = Math.floor((new Date() - new Date(profile.created_at)) / (1000 * 60 * 60 * 24));

        if (accountAgeDays >= FREE_TRIAL_DAYS) {
          return { statusCode: 403, headers: { ...corsHeaders, "Content-Type": "application/json" }, body: JSON.stringify({ error: 'TRIAL_EXPIRED' }) };
        }

        const questionsToday = profile.ai_questions_date === today ? (profile.ai_questions_today || 0) : 0;
        if (questionsToday >= FREE_DAILY_LIMIT) {
          return { statusCode: 403, headers: { ...corsHeaders, "Content-Type": "application/json" }, body: JSON.stringify({ error: 'DAILY_LIMIT_REACHED', remaining: 0 }) };
        }

        await supa.from('profiles').update({ ai_questions_today: questionsToday + 1, ai_questions_date: today }).eq('id', userId);
      }
    }

    const response = await fetch("https://api.anthropic.com/v1/messages", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "x-api-key": apiKey,
        "anthropic-version": "2023-06-01",
      },
      body: JSON.stringify({
        model: "claude-sonnet-4-6",
        max_tokens: 1024,
        stream: true,
        system: body.system || "",
        messages: body.messages,
      }),
    });

    // Stream SSE chunks back to client as plain text
    const reader = response.body.getReader();
    const decoder = new TextDecoder();
    let fullText = "";

    while (true) {
      const { done, value } = await reader.read();
      if (done) break;
      const chunk = decoder.decode(value, { stream: true });
      // Parse SSE lines for text deltas
      const lines = chunk.split("\n");
      for (const line of lines) {
        if (!line.startsWith("data: ")) continue;
        const data = line.slice(6).trim();
        if (data === "[DONE]") continue;
        try {
          const parsed = JSON.parse(data);
          if (parsed.type === "content_block_delta" && parsed.delta?.type === "text_delta") {
            fullText += parsed.delta.text;
          }
        } catch {}
      }
    }

    return {
      statusCode: 200,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
      body: JSON.stringify({ content: [{ type: "text", text: fullText }] }),
    };
  } catch (err) {
    return { statusCode: 500, headers: { ...corsHeaders, "Content-Type": "application/json" }, body: JSON.stringify({ error: err.message }) };
  }
};
